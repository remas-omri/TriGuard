import 'package:flutter/material.dart';

class LogoMini extends StatelessWidget {
  final double size;
  final String title;

  const LogoMini({
    super.key,
    this.size = 64,
    this.title = "TriGuard",
  });

  static const Color cTurquoise = Color(0xFF27D6D1);
  static const Color cSky = Color(0xFF74C7FF);
  static const Color cPurple = Color(0xFF8A7CFF);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1B2A4A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}