# Database Module – Biometric Identification System

This folder contains the database design and implementation for the
Smart Multi-Factor Biometric Security System.

## Purpose
The database is responsible for:
- Storing user information
- Storing biometric templates (Face, Voice, ECG)
- Logging all access attempts
- Generating alerts for unauthorized access

The database is designed to work with the backend APIs and receive data
from hardware devices, web application, and mobile application.

---

## Database Tables

### 1. users
Stores system users and their roles.
- user_id (Primary Key)
- full_name
- national_id
- role (admin, security, user)
- created_at

### 2. biometric_data
Stores biometric templates (not raw data) for security reasons.
- bio_id (Primary Key)
- user_id (Foreign Key)
- face_hash
- voice_hash
- ecg_hash
- last_update

### 3. login_attempts
Logs every authentication attempt.
- attempt_id (Primary Key)
- user_id (Foreign Key)
- face_result
- voice_result
- ecg_result
- final_result
- attempt_time

### 4. alerts
Stores alerts generated from failed authentication attempts.
- alert_id (Primary Key)
- attempt_id (Foreign Key)
- alert_type
- status
- created_at

---

## Relationships
- One user can have multiple login attempts
- Each login attempt can generate an alert
- Biometric data is linked to a specific user using foreign keys

Foreign keys are enforced to ensure data integrity.

---

## Security Considerations
- Biometric data is stored as hashes/templates, not raw signals
- Foreign keys prevent invalid or unauthorized records
- The database is ready to be integrated with backend authentication logic

---

## Status
- Database schema implemented
- Relationships tested and verified
- Dummy data added for testing
- Queries tested successfully

The database is ready to be connected with the backend APIs.
