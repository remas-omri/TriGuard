import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final idController = TextEditingController();
  final passController = TextEditingController();
  bool remember = true;

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'تسجيل دخول المستخدم',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),

                TriTextField(
                  hint: 'رقم الجوال او البريد الإلكتروني',
                  icon: Icons.badge_outlined,
                  controller: idController,
                ),
                const SizedBox(height: 12),
                TriTextField(
                  hint: 'كلمة المرور',
                  icon: Icons.lock_outline,
                  controller: passController,
                  obscure: true,
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Switch(
                      value: remember,
                      onChanged: (v) => setState(() => remember = v),
                      activeColor: TriColors.c2,
                    ),
                    const Text('تذكرني', style: TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('استعادة الحساب'),
                    )
                  ],
                ),

                GradientButton(
                  text: 'دخول آمن',
                  icon: Icons.shield_outlined,
                  onTap: () => Navigator.pushReplacementNamed(context, '/verify/voice'),
                  filled: true,
                ),

                const SizedBox(height: 14),
                const InfoCard(
                  icon: Icons.add_circle_outline,
                  text: 'بعد تسجيل الدخول، راح يظهر لك تحقق ثلاثي (Face/Voice/ECG) حسب سياسة النظام.',
                ),

                const Spacer(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}