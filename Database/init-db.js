const fs = require('fs');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

function resolveDbPath() {
  if (process.env.DB_PATH) return process.env.DB_PATH;

  const baseDir = process.env.DB_DIR
    || process.env.DATA_DIR
    || process.env.RENDER_DISK_PATH
    || (fs.existsSync('/var/data') ? '/var/data' : null)
    || path.join(__dirname, '..', 'data');

  if (path.extname(baseDir).toLowerCase() === '.db') return baseDir;
  return path.join(baseDir, 'triguard.db');
}

const dbPath = resolveDbPath();
const dataDir = path.dirname(dbPath);
if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

const db = new sqlite3.Database(dbPath);
db.serialize(() => {
  db.run('PRAGMA journal_mode = WAL');
  db.run('PRAGMA busy_timeout = 5000');
  db.run('PRAGMA foreign_keys = ON');
});

function run(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) return reject(err);
      resolve(this);
    });
  });
}

function get(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) return reject(err);
      resolve(row || null);
    });
  });
}

async function main() {
  await run(`CREATE TABLE IF NOT EXISTS admins (
    id INTEGER PRIMARY KEY,
    full_name TEXT,
    email TEXT,
    password TEXT,
    biometric_enabled INTEGER DEFAULT 0,
    notification_mode TEXT DEFAULT 'sound',
    push_enabled INTEGER DEFAULT 1,
    email_enabled INTEGER DEFAULT 0,
    important_only INTEGER DEFAULT 0,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_code TEXT,
    full_name TEXT,
    contact TEXT,
    password TEXT,
    status TEXT,
    face_id INTEGER,
    cmd_id INTEGER,
    finger_id INTEGER,
    biometric_enabled INTEGER DEFAULT 0,
    notification_mode TEXT DEFAULT 'sound',
    push_enabled INTEGER DEFAULT 1,
    email_enabled INTEGER DEFAULT 0,
    important_only INTEGER DEFAULT 0,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS devices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_code TEXT,
    name TEXT,
    type TEXT,
    location TEXT,
    is_active INTEGER DEFAULT 1,
    is_online INTEGER DEFAULT 1,
    last_seen TEXT,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS support_tickets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    requester_name TEXT,
    requester_contact TEXT,
    subject TEXT,
    message TEXT,
    status TEXT,
    admin_reply TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    title TEXT,
    subtitle TEXT,
    severity TEXT,
    status TEXT,
    device_name TEXT,
    user_name TEXT,
    details TEXT,
    admin_notes TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS access_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    user_name TEXT,
    device_name TEXT,
    attempt_code TEXT,
    result TEXT,
    reason TEXT,
    face_id INTEGER,
    cmd_id INTEGER,
    face_ok INTEGER DEFAULT 0,
    voice_ok INTEGER DEFAULT 0,
    ecg_ok INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS sync_state (
    id INTEGER PRIMARY KEY,
    version TEXT,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  await run(`CREATE TABLE IF NOT EXISTS device_health (
    id INTEGER PRIMARY KEY,
    device_id INTEGER,
    device_code TEXT,
    esp32_ok INTEGER DEFAULT 1,
    face_ok INTEGER DEFAULT 1,
    finger_ok INTEGER DEFAULT 1,
    voice_ok INTEGER DEFAULT 1,
    ip_address TEXT,
    wifi_ssid TEXT,
    finger_module_name TEXT DEFAULT 'Fingerprint Sensor',
    finger_module_location TEXT DEFAULT 'ESP32 Unit',
    last_heartbeat TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )`);

  const ensureColumn = async (table, column, definition) => {
    const cols = await new Promise((resolve, reject) => {
      db.all(`PRAGMA table_info(${table})`, [], (err, rows) => {
        if (err) return reject(err);
        resolve(rows || []);
      });
    });
    if (!cols.some(c => c.name === column)) {
      await run(`ALTER TABLE ${table} ADD COLUMN ${column} ${definition}`);
    }
  };

  await ensureColumn('users', 'email', 'TEXT');
  await ensureColumn('users', 'phone', 'TEXT');
  await ensureColumn('support_tickets', 'issue_type', 'TEXT');
  await ensureColumn('admins', 'biometric_enabled', 'INTEGER DEFAULT 0');
  await ensureColumn('admins', 'notification_mode', "TEXT DEFAULT 'sound'");
  await ensureColumn('admins', 'push_enabled', 'INTEGER DEFAULT 1');
  await ensureColumn('admins', 'email_enabled', 'INTEGER DEFAULT 0');
  await ensureColumn('admins', 'important_only', 'INTEGER DEFAULT 0');

  const adminExists = await get(`SELECT id FROM admins WHERE id = 1`);
  if (!adminExists) {
    await run(`
      INSERT INTO admins (id, full_name, email, password, biometric_enabled, notification_mode, push_enabled, email_enabled, important_only)
      VALUES (1, 'System Administrator', 'admin@system.local', 'admin123', 0, 'sound', 1, 0, 0)
    `);
  }

  const userCount = await get(`SELECT COUNT(*) AS c FROM users`);
  if (!userCount || userCount.c === 0) {
    await run(`
      INSERT INTO users (
        user_code, full_name, contact, email, phone, password, status,
        face_id, cmd_id, finger_id, biometric_enabled,
        notification_mode, push_enabled, email_enabled, important_only
      ) VALUES
      ('EMP-1023', 'Test User', 'testuser@triguard.com', 'testuser@triguard.com', '01000000001', '123456', 'ACTIVE', 1, 5, 1, 1, 'sound', 1, 0, 0),
      ('EMP-1024', 'Mohamed Emam', 'mohamed@example.com', 'mohamed@example.com', '01000000002', '123456', 'ACTIVE', 2, 6, 2, 0, 'sound', 1, 1, 0),
      ('EMP-1025', 'Youssef Emam', 'youssef@example.com', 'youssef@example.com', '01000000003', '123456', 'ACTIVE', 3, 7, 3, 0, 'vibration', 1, 0, 1)
    `);
  }

  const deviceCount = await get(`SELECT COUNT(*) AS c FROM devices`);
  if (!deviceCount || deviceCount.c === 0) {
    await run(`
      INSERT INTO devices (
        device_code, name, type, location, is_active, is_online, last_seen
      ) VALUES
      ('DV-01', 'بوابة 1', 'Front Camera', 'المدخل الرئيسي', 1, 1, CURRENT_TIMESTAMP),
      ('DV-02', 'بوابة 2', 'Voice Sensor', 'الدور A - الجناح الغربي', 1, 0, CURRENT_TIMESTAMP),
      ('DV-03', 'بوابة 3', 'Control Unit', 'قسم الاستقبال', 1, 1, CURRENT_TIMESTAMP),
      ('DV-04', 'بوابة 4', 'Front Camera', 'المخزن', 0, 1, CURRENT_TIMESTAMP)
    `);
  }

  const syncExists = await get(`SELECT id FROM sync_state WHERE id = 1`);
  if (!syncExists) {
    await run(`INSERT INTO sync_state (id, version) VALUES (1, ?)`, ['v-seed-1']);
  }

  const healthExists = await get(`SELECT id FROM device_health WHERE id = 1`);
  if (!healthExists) {
    await run(`
      INSERT INTO device_health (
        id, device_id, device_code, esp32_ok, face_ok, finger_ok, voice_ok,
        ip_address, wifi_ssid, last_heartbeat
      ) VALUES (
        1, 3, 'DV-03', 1, 1, 1, 1,
        '192.168.4.1', 'DoorSystem', CURRENT_TIMESTAMP
      )
    `);
  }

  console.log('Database initialized safely without reset at:', dbPath);
  db.close();
}

main().catch(err => {
  console.error(err);
  db.close();
  process.exit(1);
});
