import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import '../widgets/login_button.dart';
import 'home_page.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _id = TextEditingController();
  final _pass = TextEditingController();
  bool remember = true;

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    super.dispose();
  }

  InputDecoration _field(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.60),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: GradientBg.cSky.withOpacity(0.7), width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  "تسجيل دخول المستخدم",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1B2A4A)),
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: _id,
                decoration: _field("الرقم الوظيفي", Icons.badge_rounded),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _pass,
                obscureText: true,
                decoration: _field("كلمة المرور", Icons.lock_rounded),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: remember,
                    onChanged: (v) => setState(() => remember = v),
                    activeColor: GradientBg.cTurquoise,
                  ),
                  const Text(
                    "تذكرني",
                    style: TextStyle(color: Color(0xFF1B2A4A), fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "استعادة الحساب",
                      style: TextStyle(color: GradientBg.cPurple.withOpacity(0.9), fontWeight: FontWeight.w800),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 10),
              LoginButton(
                text: "دخول آمن",
                icon: Icons.verified_user_rounded,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage(isAdmin: false)),
                  );
                },
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
                    Icon(Icons.auto_awesome_rounded, color: GradientBg.cSky.withOpacity(0.95)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "بعد تسجيل الدخول، راح يطلب منك تحقق حيوي (وجه/صوت/ECG) حسب سياسة المكان.",
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