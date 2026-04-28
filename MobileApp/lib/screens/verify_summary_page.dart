import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';
import 'user_shell.dart';

class VerifySummaryArgs {
  final bool voicePassed;
  final bool facePassed;
  final bool ecgPassed;

  const VerifySummaryArgs({
    required this.voicePassed,
    required this.facePassed,
    required this.ecgPassed,
  });

  bool get allPassed => voicePassed && facePassed && ecgPassed;
}

class VerifySummaryPage extends StatelessWidget {
  const VerifySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as VerifySummaryArgs? ??
            const VerifySummaryArgs(voicePassed: true, facePassed: true, ecgPassed: true);

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
                const SizedBox(height: 14),

                const Text(
                  'ملخص التحقق',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'مراجعة نتائج عوامل التحقق قبل الدخول للنظام.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Colors.black.withOpacity(0.55)),
                ),
                const SizedBox(height: 16),

                _SummaryCard(
                  title: 'التحقق من الصوت',
                  subtitle: 'Voice Verification',
                  passed: args.voicePassed,
                  icon: Icons.mic_none_rounded,
                ),
                const SizedBox(height: 10),
                _SummaryCard(
                  title: 'التحقق من بصمة الوجه',
                  subtitle: 'Face Verification',
                  passed: args.facePassed,
                  icon: Icons.face_rounded,
                ),
                const SizedBox(height: 10),
                _SummaryCard(
                  title: 'التحقق من بصمة القلب (ECG)',
                  subtitle: 'ECG Verification',
                  passed: args.ecgPassed,
                  icon: Icons.favorite_rounded,
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.70),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.45)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        args.allPassed ? Icons.check_circle : Icons.error,
                        color: args.allPassed ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          args.allPassed
                              ? 'تم اجتياز جميع عوامل التحقق بنجاح.'
                              : 'لم يتم اجتياز جميع عوامل التحقق. يرجى إعادة المحاولة.',
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                if (args.allPassed)
                  GradientButton(
                    text: 'الدخول للواجهة الرئيسية',
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UserShell(initialIndex: 0)),
                    ),
                    filled: true,
                  )
                else ...[
                  GradientButton(
                    text: 'إعادة التحقق',
                    icon: Icons.refresh_rounded,
                    onTap: () => Navigator.pushReplacementNamed(context, '/verify/voice'),
                    filled: true,
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    text: 'رجوع لتسجيل الدخول',
                    icon: Icons.logout_rounded,
                    onTap: () => Navigator.pushReplacementNamed(context, '/login/user'),
                    filled: false,
                  ),
                ],

                const Spacer(),
                const FooterPill(text: 'TriGuard | عرض ملخص التحقق قبل السماح بالدخول'),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool passed;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.subtitle,
    required this.passed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color tint = passed ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(14),
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
                Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.55)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: tint,
          ),
        ],
      ),
    );
  }
} 