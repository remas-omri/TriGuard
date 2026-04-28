import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';
import 'verify_summary_page.dart';

enum VerifyState { idle, running, success, fail }

class EcgVerifyPage extends StatefulWidget {
  const EcgVerifyPage({super.key});

  @override
  State<EcgVerifyPage> createState() => _EcgVerifyPageState();
}

class _EcgVerifyPageState extends State<EcgVerifyPage> {
  VerifyState state = VerifyState.idle;

  Future<void> _start() async {
    setState(() => state = VerifyState.running);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => state = VerifyState.success);
  }

  @override
  Widget build(BuildContext context) {
    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Center(child: TriLogo(size: 70)),
                const SizedBox(height: 16),

                const Text(
                  'التحقق من بصمة القلب (ECG)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ضعي الإصبع على الحساس لقراءة الإشارة القلبية والتحقق.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                ),
                const SizedBox(height: 14),

                LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.35),
                ),
                const SizedBox(height: 16),

                _StatusCard(
                  icon: Icons.favorite_rounded,
                  title: _title(),
                  subtitle: _subtitle(),
                  state: state,
                ),

                const SizedBox(height: 18),

                if (state == VerifyState.idle)
                  GradientButton(
                    text: 'بدء التحقق',
                    icon: Icons.monitor_heart_outlined,
                    onTap: _start,
                    filled: true,
                  ),

                if (state == VerifyState.running) ...[
                  const SizedBox(height: 6),
                  const Center(child: CircularProgressIndicator()),
                ],

                if (state == VerifyState.success) ...[
                  GradientButton(
                  text: 'إنهاء والدخول',
                  icon: Icons.check_circle_outline,
                  onTap: () => Navigator.pushReplacementNamed( 
                    context,
                    '/verify/summary',
                  arguments: const VerifySummaryArgs(
                  voicePassed: true,
                  facePassed: true,
                  ecgPassed: true,
                ),
              ),
              filled: true,
            ),
                  const SizedBox(height: 10),
                  GradientButton(
                    text: 'إعادة المحاولة',
                    icon: Icons.refresh_rounded,
                    onTap: () => setState(() => state = VerifyState.idle),
                    filled: false,
                  ),
                ],

                const Spacer(),
                const FooterPill(text: 'TriGuard | تم إكمال التحقق الثلاثي بنجاح'),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _title() {
    switch (state) {
      case VerifyState.idle:
        return 'جاهز للتحقق';
      case VerifyState.running:
        return 'جاري قراءة ECG...';
      case VerifyState.success:
        return 'تم التحقق بنجاح';
      case VerifyState.fail:
        return 'فشل التحقق';
    }
  }

  String _subtitle() {
    switch (state) {
      case VerifyState.idle:
        return 'اضغطي "بدء التحقق" وانتظري ثانيتين.';
      case VerifyState.running:
        return 'رجاءً ثبتي الإصبع على الحساس.';
      case VerifyState.success:
        return 'ECG مطابق لبيانات المستخدم.';
      case VerifyState.fail:
        return 'ECG غير مطابق. حاولي مرة أخرى.';
    }
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VerifyState state;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final Color tint = switch (state) {
      VerifyState.success => const Color(0xFF16A34A),
      VerifyState.fail => const Color(0xFFDC2626),
      VerifyState.running => const Color(0xFF2563EB),
      _ => const Color(0xFF6B7280),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: tint)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12.8, color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 