import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import '../widgets/logo_mini.dart';
import 'login_type_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginTypeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoMini(size: 92, title: "TriGuard"),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  final v = 0.35 + (_c.value * 0.65);
                  return Opacity(
                    opacity: v,
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GradientBg.cSky.withOpacity(0.95),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Text(
                "Securing Identity, Smartly",
                style: TextStyle(
                  color: const Color(0xFF1B2A4A).withOpacity(0.70),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}