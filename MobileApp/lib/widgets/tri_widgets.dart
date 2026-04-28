import 'dart:ui';
import 'package:flutter/material.dart';

class TriColors {
  static const c1 = Color(0xFF2FE3D2); // تركواز
  static const c2 = Color(0xFF6A7BFF); // أزرق/بنفسجي
  static const c3 = Color(0xFF8A4DFF); // بنفسجي
  static const bgTop = Color(0xFFF3F2FF);
  static const bgMid = Color(0xFFF9FCFF);
  static const bgBottom = Color(0xFFBDF7EE);
}

class TriBackground extends StatelessWidget {
  final Widget child;
  const TriBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [TriColors.bgTop, TriColors.bgMid, TriColors.bgBottom],
        ),
      ),
      child: child,
    );
  }
}

class TriLogo extends StatelessWidget {
  final double size;
  const TriLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size * 2.6, 
          height: size * 2.0,
          child: Image.asset(
            'assets/logo.png', 
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.lock, size: 34),
          ),
        ),
        const SizedBox(height: 10),
        // const Text('TriGuard'),
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled; // true = gradient, false = white

  const GradientButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return InkWell(
      borderRadius: radius,
      onTap: onTap,
      child: Ink(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: filled
              ? const LinearGradient(colors: [TriColors.c1, TriColors.c2, TriColors.c3])
              : null,
          color: filled ? null : Colors.white.withOpacity(0.75),
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
            Icon(icon, size: 20, color: filled ? Colors.white : Colors.black87),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: filled ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TriTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController controller;

  const TriTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.white.withOpacity(0.72),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: TriColors.c2),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class FooterPill extends StatelessWidget {
  final String text;
  const FooterPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}