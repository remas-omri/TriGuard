import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isOutline;

  const LoginButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isOutline = false,
  });

  static const Color cTurquoise = Color(0xFF27D6D1);
  static const Color cSky = Color(0xFF74C7FF);
  static const Color cPurple = Color(0xFF8A7CFF);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return InkWell(
      borderRadius: radius,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: isOutline
              ? null
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [cTurquoise, cSky, cPurple],
                ),
          color: isOutline ? Colors.white.withOpacity(0.55) : null,
          border: isOutline
              ? Border.all(color: Colors.white.withOpacity(0.65), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isOutline ? const Color(0xFF1B2A4A) : Colors.white),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: TextStyle(
                color: isOutline ? const Color(0xFF1B2A4A) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}