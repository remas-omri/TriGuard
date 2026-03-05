const express = require("express");
const session = require("express-session");
const path = require("path");
const bcrypt = require("bcrypt");
require("dotenv").config();

const pool = require("./db");

const app = express();
const PORT = process.env.PORT || 3000;

// 1) قراءة بيانات الفورم + JSON
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// 2) Session
app.use(
  session({
    secret: process.env.SESSION_SECRET || "dev_secret",
    resave: false,
    saveUninitialized: false,
  })
);

// 3) ملفات ثابتة (CSS/JS)
app.use(express.static(path.join(__dirname, "public")));

// 4) EJS
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

// 5) Middleware لحماية الصفحات
function requireAuth(req, res, next) {
  if (req.session && req.session.user) return next();
  return res.redirect("/login");
}

// ---------------------- DB TEST ----------------------
app.get("/db-test", async (req, res) => {
  try {
    const r = await pool.query("SELECT NOW() as now");
    res.json({ ok: true, now: r.rows[0].now });
  } catch (e) {
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ---------------------- AUTH ----------------------

// الصفحة الرئيسية
app.get("/", (req, res) => res.redirect("/login"));

// صفحة تسجيل الدخول
app.get("/login", (req, res) => {
  res.render("login", { error: null });
});

// تسجيل الدخول من DB
app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const r = await pool.query(
      "SELECT user_id, full_name, email, password_hash, role FROM users WHERE email=$1",
      [email]
    );

    if (!r.rowCount) {
      return res.render("login", { error: "الإيميل أو كلمة المرور غير صحيحة" });
    }

    const u = r.rows[0];
    const ok = await bcrypt.compare(password, u.password_hash);

    if (!ok) {
      return res.render("login", { error: "الإيميل أو كلمة المرور غير صحيحة" });
    }

    req.session.user = {
      user_id: u.user_id,
      full_name: u.full_name,
      email: u.email,
      role: u.role,
    };

    return res.redirect("/dashboard");
  } catch (e) {
    return res.render("login", { error: "صار خطأ أثناء تسجيل الدخول" });
  }
});

// تسجيل خروج
app.post("/logout", (req, res) => {
  req.session.destroy(() => res.redirect("/login"));
});

// ---------------------- PAGES ----------------------

// Dashboard
app.get("/dashboard", requireAuth, (req, res) => {
  res.render("dashboard", { user: req.session.user });
});

// ---------------------- USERS ----------------------

// عرض المستخدمين
app.get("/users", requireAuth, async (req, res) => {
  try {
    const r = await pool.query(
      "SELECT user_id, full_name, email, role, created_at FROM users ORDER BY user_id DESC"
    );
    return res.render("users", { user: req.session.user, users: r.rows, error: null });
  } catch (e) {
    return res.render("users", { user: req.session.user, users: [], error: e.message });
  }
});

// إضافة مستخدم
app.post("/users", requireAuth, async (req, res) => {
  try {
    const { full_name, email, password, role } = req.body;

    const hash = await bcrypt.hash(password, 10);

    await pool.query(
      "INSERT INTO users(full_name, email, password_hash, role) VALUES ($1,$2,$3,$4)",
      [full_name, email, hash, role || "user"]
    );

    return res.redirect("/users");
  } catch (e) {
    const r = await pool.query(
      "SELECT user_id, full_name, email, role, created_at FROM users ORDER BY user_id DESC"
    );
    return res.render("users", {
      user: req.session.user,
      users: r.rows,
      error: "الإيميل مستخدم مسبقًا أو البيانات ناقصة",
    });
  }
});

// حذف مستخدم
app.post("/users/:id/delete", requireAuth, async (req, res) => {
  try {
    const id = Number(req.params.id);

    // منع حذف نفسك بالغلط
    if (req.session.user.user_id === id) return res.redirect("/users");

    await pool.query("DELETE FROM users WHERE user_id=$1", [id]);
    return res.redirect("/users");
  } catch (e) {
    return res.redirect("/users");
  }
});

// ---------------------- LOGS ----------------------

app.get("/logs", requireAuth, async (req, res) => {
  try {
    const r = await pool.query(`
      SELECT
        l.log_id,
        l.face_result,
        l.voice_result,
        l.ecg_result,
        l.final_result,
        l.attempt_time,
        COALESCE(u.full_name, 'Unknown') AS full_name,
        COALESCE(u.role, '-') AS role
      FROM access_logs l
      LEFT JOIN users u ON u.user_id = l.user_id
      ORDER BY l.log_id DESC
      LIMIT 200;
    `);

    return res.render("logs", {
      user: req.session.user,
      logs: r.rows,
      error: null,
    });
  } catch (e) {
    return res.render("logs", {
      user: req.session.user,
      logs: [],
      error: e.message,
    });
  }
});

// ---------------------- ALERTS ----------------------

app.get("/alerts", requireAuth, async (req, res) => {
  try {
    const r = await pool.query(`
      SELECT 
        a.alert_id,
        a.log_id,
        a.alert_type,
        a.status,
        a.created_at,
        l.final_result,
        l.attempt_time,
        COALESCE(u.full_name, 'Unknown') AS full_name,
        COALESCE(u.role, '-') AS role
      FROM alerts a
      LEFT JOIN access_logs l ON l.log_id = a.log_id
      LEFT JOIN users u ON u.user_id = l.user_id
      ORDER BY a.alert_id DESC
      LIMIT 200;
    `);

    return res.render("alerts", {
      user: req.session.user,
      alerts: r.rows,
      error: null,
    });
  } catch (e) {
    return res.render("alerts", {
      user: req.session.user,
      alerts: [],
      error: e.message,
    });
  }
});

// ---------------------- 404 ----------------------
app.use((req, res) => {
  res.status(404).send("Not found");
});

// تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`✅ Server running: http://localhost:${PORT}`);
});