const express = require("express");
const session = require("express-session");
const path = require("path");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

// 1) قراءة بيانات الفورم + JSON
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// 2) Session (تسجيل دخول)
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

// ---------------------- Routes ----------------------

// الصفحة الرئيسية
app.get("/", (req, res) => res.redirect("/login"));

// صفحة تسجيل الدخول
app.get("/login", (req, res) => {
  res.render("login", { error: null });
});

// تنفيذ تسجيل الدخول (تجريبي الآن)
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (email === "admin@demo.com" && password === "1234") {
    req.session.user = { email, role: "admin", full_name: "Admin" };
    return res.redirect("/dashboard");
  }

  return res.render("login", { error: "الإيميل أو كلمة المرور غير صحيحة" });
});

// تسجيل خروج
app.post("/logout", (req, res) => {
  req.session.destroy(() => res.redirect("/login"));
});

// Dashboard (محمية)
app.get("/dashboard", requireAuth, (req, res) => {
  res.render("dashboard", { user: req.session.user });
});

// Users (محمية)
app.get("/users", requireAuth, (req, res) => {
  res.render("users", { user: req.session.user });
});

// Logs (محمية)
app.get("/logs", requireAuth, (req, res) => {
  res.render("logs", { user: req.session.user });
});

// Alerts (محمية)
app.get("/alerts", requireAuth, (req, res) => {
  res.render("alerts", { user: req.session.user });
});

// ----------------------------------------------------

// تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`✅ Server running: http://localhost:${PORT}`);
});
