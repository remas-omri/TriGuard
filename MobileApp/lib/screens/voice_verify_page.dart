import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

enum VerifyState { idle, running, success, fail }

class VoiceVerifyPage extends StatefulWidget {
  const VoiceVerifyPage({super.key});

  @override
  State<VoiceVerifyPage> createState() => _VoiceVerifyPageState();
}

class _VoiceVerifyPageState extends State<VoiceVerifyPage> {
  VerifyState state = VerifyState.idle;

  Future<void> _start() async {
    setState(() => state = VerifyState.running);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => state = VerifyState.success); // محاكاة نجاح
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
                  'التحقق من الصوت',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'رجاءً تحدث بجملة قصيرة للتأكد من هوية المستخدم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                ),
                const SizedBox(height: 14),

                LinearProgressIndicator(
                  value: 0.33,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.35),
                ),
                const SizedBox(height: 16),

                _StatusCard(
                  icon: Icons.mic_none_rounded,
                  title: _title(),
                  subtitle: _subtitle(),
                  state: state,
                ),

                const SizedBox(height: 18),

                if (state == VerifyState.idle)
                  GradientButton(
                    text: 'بدء التحقق',
                    icon: Icons.play_arrow_rounded,
                    onTap: _start,
                    filled: true,
                  ),

                if (state == VerifyState.running) ...[
                  const SizedBox(height: 6),
                  const Center(child: CircularProgressIndicator()),
                ],

                if (state == VerifyState.success) ...[
                  GradientButton(
                    text: 'التالي',
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pushReplacementNamed(context, '/verify/face'),
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
                const FooterPill(text: 'TriGuard | التحقق متعدد العوامل (Face / Voice / ECG)'),
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
        return 'جاري الاستماع...';
      case VerifyState.success:
        return 'تم التحقق بنجاح';
      case VerifyState.fail:
        return 'فشل التحقق';
    }
  }

  String _subtitle() {
    switch (state) {
      case VerifyState.idle:
        return 'اضغطي "بدء التحقق" وابدئي بالتحدث.';
      case VerifyState.running:
        return 'رجاءً تحدث الآن لمدة ثانيتين.';
      case VerifyState.success:
        return 'الصوت مطابق لبيانات المستخدم.';
      case VerifyState.fail:
        return 'الصوت غير مطابق. حاولي مرة أخرى.';
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