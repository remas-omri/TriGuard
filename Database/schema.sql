CREATE TABLE admins (
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
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_code TEXT,
  full_name TEXT,
  contact TEXT,
  email TEXT,
  phone TEXT,
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
);

CREATE TABLE devices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  device_code TEXT,
  name TEXT,
  type TEXT,
  location TEXT,
  is_active INTEGER DEFAULT 1,
  is_online INTEGER DEFAULT 1,
  last_seen TEXT,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE support_tickets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  requester_name TEXT,
  requester_contact TEXT,
  subject TEXT,
  message TEXT,
  status TEXT,
  admin_reply TEXT,
  issue_type TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerts (
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
);

CREATE TABLE access_logs (
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
);

CREATE TABLE sync_state (
  id INTEGER PRIMARY KEY,
  version TEXT,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE device_health (
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
);