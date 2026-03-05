const bcrypt = require("bcrypt");
const pool = require("./db");

(async () => {
  try {
    const email = "admin@demo.com";
    const password = "1234";
    const full_name = "Admin";
    const role = "admin";

    const exists = await pool.query("SELECT 1 FROM users WHERE email=$1", [email]);

    if (!exists.rowCount) {
      const hash = await bcrypt.hash(password, 10);
      await pool.query(
        "INSERT INTO users(full_name,email,password_hash,role) VALUES($1,$2,$3,$4)",
        [full_name, email, hash, role]
      );
      console.log("✅ Admin created: admin@demo.com / 1234");
    } else {
      console.log("ℹ️ Admin already exists: admin@demo.com");
    }

    process.exit(0);
  } catch (e) {
    console.error("❌ create_admin error:", e.message);
    process.exit(1);
  }
})();
