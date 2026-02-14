const jwt = require("jsonwebtoken");

function signToken(user) {
  const secret = process.env.JWT_SECRET;
  if (!secret) throw new Error("JWT_SECRET missing");

  return jwt.sign(
    { user_id: user.user_id, role: user.role },
    secret,
    { expiresIn: "12h" }
  );
}

function requireAuth(req, res, next) {
  const h = req.headers.authorization || "";
  const m = h.match(/^Bearer\s+(.+)$/i);
  if (!m) return res.status(401).json({ ok: false, message: "Missing Authorization Bearer token" });

  try {
    const payload = jwt.verify(m[1], process.env.JWT_SECRET);
    req.auth = payload; // { user_id, role, iat, exp }
    next();
  } catch (e) {
    return res.status(401).json({ ok: false, message: "Invalid token" });
  }
}

function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.auth?.role) return res.status(401).json({ ok: false, message: "Unauthorized" });
    if (!roles.includes(req.auth.role)) return res.status(403).json({ ok: false, message: "Forbidden" });
    next();
  };
}

module.exports = { signToken, requireAuth, requireRole };
