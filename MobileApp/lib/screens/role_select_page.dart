import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                const SizedBox(height: 26),
                const TriLogo(size: 100),
                const SizedBox(height: 22),
                const Text(
                  'اختر نوع تسجيل الدخول',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 28),

                GradientButton(
                  text: 'User',
                  icon: Icons.person_outline,
                  onTap: () => Navigator.pushNamed(context, '/login/user'),
                  filled: true,
                ),
                const SizedBox(height: 14),
                GradientButton(
                  text: 'Admin',
                  icon: Icons.verified_user_outlined,
                  onTap: () => Navigator.pushNamed(context, '/login/admin'),
                  filled: false,
                ),

                const Spacer(),
                const FooterPill(text: 'TriGuard | يعتمد على تحقق متعدد العوامل'),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}