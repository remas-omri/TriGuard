import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                  'تسجيل دخول المسؤول',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),

                TriTextField(
                  hint: 'رقم الجوال او البريد الإلكتروني',
                  icon: Icons.alternate_email_rounded,
                  controller: emailController,
                ),
                const SizedBox(height: 12),
                TriTextField(
                  hint: 'كلمة المرور',
                  icon: Icons.lock_outline,
                  controller: passController,
                  obscure: true,
                ),

                const SizedBox(height: 14),
                GradientButton(
                  text: 'دخول لوحة التحكم',
                  icon: Icons.dashboard_outlined,
                  onTap: () => Navigator.pushReplacementNamed(context, '/home/admin'),
                  filled: true,
                ),

                const SizedBox(height: 14),
                const InfoCard(
                  icon: Icons.verified_user_outlined,
                  text: 'صلاحيات المسؤول لتعديل التنبيهات، عرض السجلات، ومتابعة الأجهزة المرتبطة.',
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