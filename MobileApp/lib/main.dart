import 'package:flutter/material.dart';

import 'screens/role_select_page.dart';
import 'screens/user_login_page.dart';
import 'screens/admin_login_page.dart';
import 'screens/user_home_dummy.dart';
import 'screens/admin_home_dummy.dart';
import 'screens/voice_verify_page.dart';
import 'screens/face_verify_page.dart';
import 'screens/ecg_verify_page.dart';
import 'screens/verify_summary_page.dart';

void main() {
  runApp(const TriGuardApp());
}

class TriGuardApp extends StatelessWidget {
  const TriGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TriGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      initialRoute: '/role',
      routes: {
        '/role': (_) => const RoleSelectPage(),
        '/login/user': (_) => const UserLoginPage(),
        '/login/admin': (_) => const AdminLoginPage(),
        '/home/user': (_) => const UserHomeDummy(),
        '/home/admin': (_) => const AdminHomeDummy(),
        '/verify/voice': (_) => const VoiceVerifyPage(),
        '/verify/face': (_) => const FaceVerifyPage(),
        '/verify/ecg': (_) => const EcgVerifyPage(),
        '/verify/summary': (_) => const VerifySummaryPage(),
      },
    );
  }
} 