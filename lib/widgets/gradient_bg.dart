import 'dart:ui';
import 'package:flutter/material.dart';

class GradientBg extends StatelessWidget {
  final Widget child;
  final bool showGlow;

  const GradientBg({
    super.key,
    required this.child,
    this.showGlow = true,
  });

  static const Color cTurquoise = Color(0xFF27D6D1);
  static const Color cSky = Color(0xFF74C7FF);
  static const Color cPurple = Color(0xFF8A7CFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAFBFF),
            Color(0xFFEDEBFF),
            Color(0xFFE8FFF7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Soft blobs
          Positioned(
            top: -120,
            left: -80,
            child: _Blob(color: cSky.withOpacity(0.35), size: 260),
          ),
          Positioned(
            top: 120,
            right: -110,
            child: _Blob(color: cPurple.withOpacity(0.30), size: 280),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: _Blob(color: cTurquoise.withOpacity(0.30), size: 300),
          ),

          // Light sparkles overlay
          if (showGlow)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.6, -0.2),
                      radius: 1.1,
                      colors: [
                        Colors.white.withOpacity(0.65),
                        Colors.white.withOpacity(0.00),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Blur layer for elegance
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(color: Colors.white.withOpacity(0.03)),
            ),
          ),

          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            blurRadius: 60,
            spreadRadius: 10,
            color: color.withOpacity(0.35),
          )
        ],
      ),
    );
  }
}