import 'package:flutter/material.dart';
import 'page/splash_screen.dart';

void main() => runApp(const TriGuardApp());

class TriGuardApp extends StatelessWidget {
  const TriGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TriGuard',

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}