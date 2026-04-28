# 📊 Database Design – TriGuard System

## 🧠 Overview

This project focuses on designing and managing the database for the TriGuard security system.
The database is responsible for storing user data, device information, alerts, and access logs.

---

## 🗄️ Database Technology

* SQLite (used during development)
* Structured using SQL
* Integrated with Node.js backend

---

## 📁 Files Included

* `schema.sql` → يحتوي على جميع أوامر إنشاء الجداول
* `init-db.js` → سكربت لإنشاء قاعدة البيانات والجداول
* `db.js` → ملف الاتصال بقاعدة البيانات

---

## 📊 Main Tables

### 👤 Users

Stores user information and biometric settings.

* id
* full_name
* email
* phone
* biometric_enabled

---

### 🛠️ Devices

Stores device details.

* id
* device_code
* name
* location
* status

---

### 🚨 Alerts

Stores system alerts and notifications.

* id
* user_id
* title
* severity
* status

---

### 📜 Access Logs

Stores authentication attempts.

* id
* user_id
* result
* reason
* created_at

---

### 🧾 Support Tickets

Stores user support requests.

* id
* user_id
* subject
* status

---

## 🔗 Relationships

* User ↔ Alerts
* User ↔ Access Logs
* User ↔ Support Tickets

---

## ⚙️ How to Use

1. Run `init-db.js` to create the database
2. Or import `schema.sql` manually
3. Connect using `db.js`

---

## 🔐 Notes

* No real user data is included
* Database is structured for scalability and security

---

## 👩‍💻 Author Role

Responsible for:

* Designing database tables
* Implementing schema
* Connecting database to backend
* Managing data structure

---
