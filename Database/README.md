# Database Module – Secure Access System

This folder contains the database schema and SQL exports for the
Smart Multi-Factor Biometric Security System (Face + Voice + ECG).

## Purpose
The database is responsible for:
- Storing user accounts and roles
- Storing biometric templates (not raw signals)
- Registering devices (ESP32) securely
- Logging access attempts
- Storing verification factor results (Face/Voice/ECG)
- Generating alerts for unauthorized/failed attempts
- Recording audit logs for administrative actions

---

## Main Tables

### 1) roles
Defines system roles.
- role_id (PK)
- name (admin, security, user)

### 2) users
Stores system users and their role.
- user_id (PK)
- full_name
- national_id
- email
- phone
- password_hash
- role_id (FK → roles.role_id)
- is_active
- created_at

### 3) user_biometrics
Stores biometric templates/hashes per user (NOT raw biometrics).
- user_id (PK/FK → users.user_id)
- face_template / face_hash (optional)
- voice_template / voice_hash (optional)
- ecg_template / ecg_hash (optional)
- updated_at

### 4) devices
Registers hardware devices (ESP32) securely.
- device_id (PK)
- serial (unique)
- location
- api_key_hash (hashed device key)
- is_active
- created_at

### 5) attempts
Logs each access attempt (one row per attempt).
- attempt_id (PK)
- device_id (FK → devices.device_id)
- user_id (FK → users.user_id) nullable
- attempt_time
- final_result (passed/failed)
- status (recorded/...)
- failure_reason (nullable)
- ip_address
- user_agent
- meta (JSON/text)
- created_at

### 6) verification_results
Stores the results of each factor per attempt (3 rows per attempt).
- id (PK) OR (attempt_id + method as unique)
- attempt_id (FK → attempts.attempt_id)
- method (face/voice/ecg)
- result (pass/fail/na)
- score (nullable)
- created_at

### 7) alerts
Stores alerts generated when verification fails or unauthorized attempt occurs.
- alert_id (PK)
- attempt_id (FK → attempts.attempt_id)
- alert_type (unauthorized_attempt / verification_failed / ...)
- status (pending/acknowledged)
- message
- created_at
- acknowledged_at
- acknowledged_by (FK → users.user_id) nullable

### 8) audit_logs
Tracks administrative actions for accountability.
- log_id (PK)
- actor_user_id (FK → users.user_id)
- action
- entity
- entity_id
- meta
- created_at

---

## Relationships
- One role → many users
- One user → one biometrics row (1:1)
- One device → many attempts (1:N)
- One attempt → many verification_results (1:N)
- One attempt → zero/one or more alerts (1:N)
- One admin/security user → many audit logs (1:N)

---

## Security Considerations
- Passwords stored as hashes (password_hash)
- Device keys stored as hashes (api_key_hash)
- Biometric data stored as templates/hashes (not raw signals)
- Results normalized: verification results stored in verification_results (avoids duplication and supports future expansion)
- Soft-disable supported via is_active for users/devices

---

## Status
- Schema implemented and tested
- Relationships verified (foreign keys)
- Backend API connected and inserting attempts + verification_results successfully
