import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import '../widgets/login_button.dart';
import 'admin_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  InputDecoration _field(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: GradientBg.cPurple.withOpacity(0.7), width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _goAdmin() {
    // (لاحقًا تربطين التحقق الحقيقي من الباك اند)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1B2A4A)),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "تسجيل دخول المسؤول",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1B2A4A),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: _email,
                decoration: _field("رقم الجوال  او البريد الالكتروني", Icons.alternate_email_rounded),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _pass,
                obscureText: true,
                onSubmitted: (_) => _goAdmin(),
                decoration: _field("كلمة المرور", Icons.lock_rounded),
              ),

              const SizedBox(height: 16),
              LoginButton(
                text: "دخول لوحة التحكم",
                icon: Icons.dashboard_rounded,
                onTap: _goAdmin,
              ),

              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.65)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security_rounded, color: GradientBg.cTurquoise.withOpacity(0.95)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "صلاحيات المسؤول تشمل التنبيهات، السجلات، وإدارة الأجهزة المرتبطة.",
                        style: TextStyle(
                          color: const Color(0xFF1B2A4A).withOpacity(0.70),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}