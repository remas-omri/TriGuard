require("dotenv").config();
const express = require("express");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const { pool } = require("./db");
const { signToken, requireAuth, requireRole } = require("./auth");

const app = express();
app.use(express.json());

// ✅ Root
app.get("/", (req, res) => {
  res.send("Secure Access API is running ✅ Try /health");
});

// ---------- Helpers ----------
function must(v, msg) {
  if (v === undefined || v === null || v === "") throw new Error(msg);
  return v;
}

function genApiKey() {
  return crypto.randomBytes(32).toString("hex");
}

function hashDeviceKey(rawKey) {
  const pepper = process.env.DEVICE_KEY_PEPPER || "";
  return bcrypt.hashSync(rawKey + pepper, 10);
}

async function verifyDeviceKey(rawKey, storedHash) {
  const pepper = process.env.DEVICE_KEY_PEPPER || "";
  return bcrypt.compare(rawKey + pepper, storedHash);
}

function getClientIp(req) {
  const xff = req.headers["x-forwarded-for"];
  if (typeof xff === "string" && xff.length) return xff.split(",")[0].trim();
  return req.socket?.remoteAddress || null;
}

function shouldCreateAlert(body) {
  const faceFail = body.face_result === "fail";
  const voiceFail = body.voice_result === "fail";
  const ecgFail = body.ecg_result === "fail";
  return body.final_result === "failed" || !body.user_id || faceFail || voiceFail || ecgFail;
}

function alertType(body) {
  if (!body.user_id) return "unauthorized_attempt";
  if (
    body.final_result === "failed" ||
    body.face_result === "fail" ||
    body.voice_result === "fail" ||
    body.ecg_result === "fail"
  )
    return "verification_failed";
  return "system";
}

// attempts columns cache (عشان status/ip/user_agent لو موجودة)
let attemptsColumnsCache = null;
async function getAttemptsColumns(conn) {
  if (attemptsColumnsCache) return attemptsColumnsCache;

  const [rows] = await conn.query(
    `SELECT COLUMN_NAME AS name
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
       AND TABLE_NAME = 'attempts'`
  );

  attemptsColumnsCache = new Set(rows.map((r) => r.name));
  return attemptsColumnsCache;
}

// ---------- Health ----------
app.get("/health", (req, res) => res.json({ ok: true }));

// ---------- Auth ----------
app.post("/api/v1/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    must(email, "email required");
    must(password, "password required");

    const [rows] = await pool.query(
      `SELECT u.user_id, u.email, u.password_hash, r.name AS role, u.is_active
       FROM users u
       JOIN roles r ON r.role_id = u.role_id
       WHERE u.email = :email
       LIMIT 1`,
      { email }
    );

    if (!rows.length) return res.status(401).json({ ok: false, message: "Invalid credentials" });

    const user = rows[0];
    if (!user.is_active) return res.status(403).json({ ok: false, message: "User inactive" });
    if (!user.password_hash) return res.status(401).json({ ok: false, message: "No password set" });

    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) return res.status(401).json({ ok: false, message: "Invalid credentials" });

    const token = signToken(user);
    return res.json({
      ok: true,
      token,
      user: { user_id: user.user_id, email: user.email, role: user.role }
    });
  } catch (e) {
    return res.status(400).json({ ok: false, message: e.message });
  }
});

// ---------- Users (Admin creates users) ----------
app.post("/api/v1/users", requireAuth, requireRole("admin"), async (req, res) => {
  try {
    const { full_name, national_id, email, phone, role = "user", password } = req.body;

    must(full_name, "full_name required");
    must(national_id, "national_id required");
    must(password, "password required");

    const [rrows] = await pool.query(`SELECT role_id FROM roles WHERE name=:name LIMIT 1`, {
      name: role
    });
    if (!rrows.length) throw new Error("Invalid role");

    const password_hash = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      `INSERT INTO users (full_name, national_id, email, phone, password_hash, role_id)
       VALUES (:full_name, :national_id, :email, :phone, :password_hash, :role_id)`,
      {
        full_name,
        national_id,
        email: email || null,
        phone: phone || null,
        password_hash,
        role_id: rrows[0].role_id
      }
    );

    await pool.query(`INSERT INTO user_biometrics (user_id) VALUES (:id)`, { id: result.insertId });

    return res.status(201).json({ ok: true, user_id: result.insertId });
  } catch (e) {
    return res.status(400).json({ ok: false, message: e.message });
  }
});

app.get("/api/v1/users", requireAuth, requireRole("admin", "security"), async (req, res) => {
  const [rows] = await pool.query(
    `SELECT u.user_id, u.full_name, u.national_id, u.email, u.phone,
            r.name AS role, u.is_active, u.created_at
     FROM users u
     JOIN roles r ON r.role_id=u.role_id
     ORDER BY u.user_id DESC`
  );
  res.json({ ok: true, data: rows });
});

// ---------- Devices ----------
app.post("/api/v1/devices", requireAuth, requireRole("admin"), async (req, res) => {
  try {
    const { serial, location } = req.body;
    must(serial, "serial required");

    const apiKey = genApiKey();
    const api_key_hash = hashDeviceKey(apiKey);

    const [result] = await pool.query(
      `INSERT INTO devices (serial, location, api_key_hash)
       VALUES (:serial, :location, :api_key_hash)`,
      { serial, location: location || null, api_key_hash }
    );

    return res.status(201).json({ ok: true, device_id: result.insertId, api_key: apiKey });
  } catch (e) {
    return res.status(400).json({ ok: false, message: e.message });
  }
});

// ✅ List devices (Admin/Security)
app.get("/api/v1/devices", requireAuth, requireRole("admin", "security"), async (req, res) => {
  const [rows] = await pool.query(
    `SELECT device_id, serial, location, is_active, created_at
     FROM devices
     ORDER BY device_id DESC`
  );
  res.json({ ok: true, data: rows });
});

// ✅ Disable device (Admin)
app.patch("/api/v1/devices/:id/disable", requireAuth, requireRole("admin"), async (req, res) => {
  await pool.query(`UPDATE devices SET is_active = 0 WHERE device_id = :id`, { id: req.params.id });
  res.json({ ok: true });
});

// ✅ Enable device (Admin)
app.patch("/api/v1/devices/:id/enable", requireAuth, requireRole("admin"), async (req, res) => {
  await pool.query(`UPDATE devices SET is_active = 1 WHERE device_id = :id`, { id: req.params.id });
  res.json({ ok: true });
});

// ---------- Device Auth Middleware ----------
async function requireDevice(req, res, next) {
  const rawKey = req.header("X-Device-Key");
  const serial = req.header("X-Device-Serial");
  if (!rawKey || !serial) return res.status(401).json({ ok: false, message: "Missing device headers" });

  const [rows] = await pool.query(
    `SELECT device_id, api_key_hash, is_active
     FROM devices
     WHERE serial=:serial
     LIMIT 1`,
    { serial }
  );

  if (!rows.length) return res.status(401).json({ ok: false, message: "Unknown device" });
  if (!rows[0].is_active) return res.status(403).json({ ok: false, message: "Device inactive" });

  const ok = await verifyDeviceKey(rawKey, rows[0].api_key_hash);
  if (!ok) return res.status(401).json({ ok: false, message: "Bad device key" });

  req.device = { device_id: rows[0].device_id, serial };
  next();
}

// ---------- Attempts (Device posts results) ----------
// ✅ attempts = محاولة فقط
// ✅ verification_results = نتائج face/voice/ecg
app.post("/api/v1/attempts", requireDevice, async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const body = req.body;
    must(body.final_result, "final_result required (passed/failed)");

    const cols = await getAttemptsColumns(conn);

    const attemptPayload = {
      device_id: req.device.device_id,
      user_id: body.user_id || null,
      final_result: body.final_result,
      meta: body.meta ? JSON.stringify(body.meta) : null
    };

    if (cols.has("status")) attemptPayload.status = body.status || "recorded";
    if (cols.has("failure_reason")) attemptPayload.failure_reason = body.failure_reason || null;
    if (cols.has("ip_address")) attemptPayload.ip_address = getClientIp(req);
    if (cols.has("user_agent")) attemptPayload.user_agent = req.get("User-Agent") || null;

    const factors = {
      face_result: body.face_result || "na",
      voice_result: body.voice_result || "na",
      ecg_result: body.ecg_result || "na",
      face_score: body.face_confidence ?? null,
      voice_score: body.voice_confidence ?? null,
      ecg_score: body.ecg_confidence ?? null
    };

    await conn.beginTransaction();

    const insertCols = Object.keys(attemptPayload);
    const [r1] = await conn.query(
      `INSERT INTO attempts (${insertCols.join(", ")})
       VALUES (${insertCols.map((c) => ":" + c).join(", ")})`,
      attemptPayload
    );

    const attempt_id = r1.insertId;

    await conn.query(
      `INSERT INTO verification_results (attempt_id, method, result, score)
       VALUES
       (:attempt_id, 'face',  :face_result,  :face_score),
       (:attempt_id, 'voice', :voice_result, :voice_score),
       (:attempt_id, 'ecg',   :ecg_result,   :ecg_score)`,
      { attempt_id, ...factors }
    );

    let alert_created = false;
    let alert_id = null;

    if (shouldCreateAlert({ ...body, user_id: attemptPayload.user_id })) {
      const type = alertType({ ...body, user_id: attemptPayload.user_id });
      const msg = type === "unauthorized_attempt" ? "Unknown user attempted access" : "Verification failed";

      const [ares] = await conn.query(
        `INSERT INTO alerts (attempt_id, alert_type, message)
         VALUES (:attempt_id, :alert_type, :message)`,
        { attempt_id, alert_type: type, message: msg }
      );

      alert_created = true;
      alert_id = ares.insertId;
    }

    await conn.commit();
    return res.status(201).json({ ok: true, attempt_id, alert_created, alert_id });
  } catch (e) {
    try {
      await conn.rollback();
    } catch {}
    return res.status(400).json({ ok: false, message: e.message });
  } finally {
    conn.release();
  }
});

// ---------- Attempts list (Admin/Security) ----------
app.get("/api/v1/attempts", requireAuth, requireRole("admin", "security"), async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const cols = await getAttemptsColumns(conn);
    const extraSelect = [];
    if (cols.has("status")) extraSelect.push("a.status");
    if (cols.has("failure_reason")) extraSelect.push("a.failure_reason");
    if (cols.has("ip_address")) extraSelect.push("a.ip_address");
    if (cols.has("user_agent")) extraSelect.push("a.user_agent");

    const sql = `
      SELECT
        a.attempt_id,
        a.attempt_time,
        a.final_result,
        ${extraSelect.length ? extraSelect.join(", ") + "," : ""}
        a.meta,
        d.serial AS device_serial,
        u.full_name,

        MAX(CASE WHEN vr.method='face'  THEN vr.result END) AS face_result,
        MAX(CASE WHEN vr.method='voice' THEN vr.result END) AS voice_result,
        MAX(CASE WHEN vr.method='ecg'   THEN vr.result END) AS ecg_result,

        MAX(CASE WHEN vr.method='face'  THEN vr.score END) AS face_score,
        MAX(CASE WHEN vr.method='voice' THEN vr.score END) AS voice_score,
        MAX(CASE WHEN vr.method='ecg'   THEN vr.score END) AS ecg_score

      FROM attempts a
      JOIN devices d ON d.device_id = a.device_id
      LEFT JOIN users u ON u.user_id = a.user_id
      LEFT JOIN verification_results vr ON vr.attempt_id = a.attempt_id
      GROUP BY a.attempt_id
      ORDER BY a.attempt_id DESC
      LIMIT 200
    `;

    const [rows] = await conn.query(sql);
    res.json({ ok: true, data: rows });
  } finally {
    conn.release();
  }
});

// ---------- Alerts (Admin/Security) ----------
app.get("/api/v1/alerts", requireAuth, requireRole("admin", "security"), async (req, res) => {
  const [rows] = await pool.query(
    `SELECT al.*, a.final_result, a.attempt_time, u.full_name, d.serial AS device_serial
     FROM alerts al
     JOIN attempts a ON a.attempt_id=al.attempt_id
     JOIN devices d ON d.device_id=a.device_id
     LEFT JOIN users u ON u.user_id=a.user_id
     ORDER BY al.alert_id DESC
     LIMIT 200`
  );
  res.json({ ok: true, data: rows });
});

app.patch("/api/v1/alerts/:id/ack", requireAuth, requireRole("admin", "security"), async (req, res) => {
  await pool.query(
    `UPDATE alerts
     SET status='acknowledged', acknowledged_at=NOW(), acknowledged_by=:by
     WHERE alert_id=:id`,
    { id: req.params.id, by: req.auth.user_id }
  );
  res.json({ ok: true });
});

// ---------- 404 ----------
app.use((req, res) => {
  res.status(404).json({ ok: false, message: "Not found" });
});

// ---------- Start ----------
const port = Number(process.env.PORT || 3000);
app.listen(port, () => console.log(`API running on http://localhost:${port}`));
