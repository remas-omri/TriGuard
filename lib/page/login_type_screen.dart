import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import '../widgets/login_button.dart';
import '../widgets/logo_mini.dart';
import 'user_login_page.dart';
import 'admin_login_page.dart';

class LoginTypeScreen extends StatelessWidget {
  const LoginTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1B2A4A)),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              const LogoMini(size: 78, title: "TriGuard"),
              const SizedBox(height: 18),
              const Text(
                "اختر نوع تسجيل الدخول",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2A4A),
                ),
              ),
              
              const Spacer(),

              // Big buttons (User / Admin)
              LoginButton(
                text: "User",
                icon: Icons.person_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserLoginPage()),
                ),
              ),
              const SizedBox(height: 14),
              LoginButton(
                text: "Admin",
                icon: Icons.admin_panel_settings_rounded,
                isOutline: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminLoginPage()),
                ),
              ),

              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.65)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded, size: 18, color: const Color(0xFF1B2A4A).withOpacity(0.75)),
                    
          
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}