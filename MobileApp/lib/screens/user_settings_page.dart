import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

enum NotifyMode { sound, vibrate, silent }

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  // ---- Security Settings ----
  bool biometricLock = true;

  // ---- Notification Preferences ----
  NotifyMode notifyMode = NotifyMode.sound;

  bool alertFailedVerification = true;
  bool alertSuspiciousAttempt = true;
  bool alertLoginSuccess = false;

  // ---------- Actions ----------
  void _openChangePasswordSheet() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'تغيير كلمة المرور',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),

                TriTextField(
                  hint: 'كلمة المرور الحالية',
                  icon: Icons.lock_outline,
                  controller: currentCtrl,
                  obscure: true,
                ),
                const SizedBox(height: 10),
                TriTextField(
                  hint: 'كلمة المرور الجديدة',
                  icon: Icons.password_rounded,
                  controller: newCtrl,
                  obscure: true,
                ),
                const SizedBox(height: 10),
                TriTextField(
                  hint: 'تأكيد كلمة المرور الجديدة',
                  icon: Icons.verified_rounded,
                  controller: confirmCtrl,
                  obscure: true,
                ),

                const SizedBox(height: 14),
                GradientButton(
                  text: 'حفظ التغيير',
                  icon: Icons.check_circle_outline,
                  filled: true,
                  onTap: () {
                    final cur = currentCtrl.text.trim();
                    final nw = newCtrl.text.trim();
                    final cf = confirmCtrl.text.trim();

                    if (cur.isEmpty || nw.isEmpty || cf.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('كمّلي جميع الحقول')),
                      );
                      return;
                    }
                    if (nw.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('كلمة المرور الجديدة قصيرة (6 أحرف على الأقل)')),
                      );
                      return;
                    }
                    if (nw != cf) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('التأكيد لا يطابق كلمة المرور الجديدة')),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح ✅')),
                    );
                  },
                ),
                const SizedBox(height: 10),
                GradientButton(
                  text: 'إلغاء',
                  icon: Icons.close_rounded,
                  filled: false,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _notifyModeLabel(NotifyMode m) {
    switch (m) {
      case NotifyMode.sound:
        return 'صوت';
      case NotifyMode.vibrate:
        return 'اهتزاز';
      case NotifyMode.silent:
        return 'صامت';
    }
  }

  IconData _notifyModeIcon(NotifyMode m) {
    switch (m) {
      case NotifyMode.sound:
        return Icons.volume_up_rounded;
      case NotifyMode.vibrate:
        return Icons.vibration_rounded;
      case NotifyMode.silent:
        return Icons.notifications_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 18),
          Center(child: TriLogo(size: 70)),
          const SizedBox(height: 10),

          const Text(
            'الإعدادات',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'إعدادات الأمان والإشعارات لرفع حماية الحساب وتخصيص التنبيهات.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: Colors.black.withOpacity(0.55)),
          ),
          const SizedBox(height: 16),

          _SectionTitle(title: 'إعدادات الأمان'),
          const SizedBox(height: 10),

          _GlassActionTile(
            icon: Icons.lock_reset_rounded,
            title: 'تغيير كلمة المرور',
            subtitle: 'تحديث كلمة مرور الحساب',
            trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black54),
            onTap: _openChangePasswordSheet,
          ),
          const SizedBox(height: 10),

          _GlassSwitchTile(
            icon: Icons.fingerprint_rounded,
            title: 'قفل التطبيق بالبصمة',
            subtitle: 'FaceID / TouchID (حسب الجهاز)',
            value: biometricLock,
            onChanged: (v) {
              setState(() => biometricLock = v);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(v ? 'تم تفعيل القفل بالبصمة ✅' : 'تم إيقاف القفل بالبصمة')),
              );
            },
          ),
          const SizedBox(height: 12),

          GradientButton(
            text: 'تسجيل الخروج',
            icon: Icons.logout_rounded,
            filled: false,
            onTap: () => Navigator.pushReplacementNamed(context, '/login/user'),
          ),

          const SizedBox(height: 18),
          _SectionTitle(title: 'إعدادات الإشعارات'),
          const SizedBox(height: 10),

          _GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('طريقة التنبيه', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),

                _ModeRow(
                  icon: _notifyModeIcon(NotifyMode.sound),
                  label: 'صوت',
                  selected: notifyMode == NotifyMode.sound,
                  onTap: () => setState(() => notifyMode = NotifyMode.sound),
                ),
                _ModeRow(
                  icon: _notifyModeIcon(NotifyMode.vibrate),
                  label: 'اهتزاز',
                  selected: notifyMode == NotifyMode.vibrate,
                  onTap: () => setState(() => notifyMode = NotifyMode.vibrate),
                ),
                _ModeRow(
                  icon: _notifyModeIcon(NotifyMode.silent),
                  label: 'صامت',
                  selected: notifyMode == NotifyMode.silent,
                  onTap: () => setState(() => notifyMode = NotifyMode.silent),
                ),

                const SizedBox(height: 8),
                Text(
                  'الوضع الحالي: ${_notifyModeLabel(notifyMode)}',
                  style: TextStyle(fontSize: 12.5, color: Colors.black.withOpacity(0.55), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _GlassSwitchTile(
            icon: Icons.close_rounded,
            title: 'تنبيه فشل التحقق',
            subtitle: 'عند فشل Voice/Face/ECG',
            value: alertFailedVerification,
            onChanged: (v) => setState(() => alertFailedVerification = v),
          ),
          const SizedBox(height: 10),
          _GlassSwitchTile(
            icon: Icons.warning_amber_rounded,
            title: 'تنبيه محاولة غير طبيعية',
            subtitle: 'عند الاشتباه بمحاولة دخول',
            value: alertSuspiciousAttempt,
            onChanged: (v) => setState(() => alertSuspiciousAttempt = v),
          ),
          const SizedBox(height: 10),
          _GlassSwitchTile(
            icon: Icons.check_circle_outline,
            title: 'تنبيه تسجيل دخول ناجح',
            subtitle: 'إشعار عند نجاح الدخول',
            value: alertLoginSuccess,
            onChanged: (v) => setState(() => alertLoginSuccess = v),
          ),
           
           const SizedBox(height: 18),
          _SectionTitle(title: 'الدعم الفني'),
          const SizedBox(height: 10),
          _GlassActionTile(
          icon: Icons.support_agent_rounded,
          title: 'التواصل مع الدعم الفني',
          subtitle: 'إرسال رسالة للدعم',
          trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black54),
          onTap: () {
          showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const _SupportSheet(),
         );
       },
      ),
          
          const SizedBox(height: 14),
          const FooterPill(text: 'TriGuard | تخصيص الأمان والتنبيهات'),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w900,
          color: Colors.black.withOpacity(0.70),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: child,
    );
  }
}

class _GlassActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _GlassActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
                color: TriColors.c2.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: TriColors.c2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: Colors.black.withOpacity(0.55))),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _GlassSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GlassSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              color: TriColors.c2.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: TriColors.c2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: Colors.black.withOpacity(0.55))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: TriColors.c2,
          ),
        ],
      ),
    );
  }
}

class _ModeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color tint = selected ? const Color(0xFF2563EB) : Colors.black54;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tint.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: tint),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }
} 

class _SupportSheet extends StatelessWidget {
  const _SupportSheet();

  @override
  Widget build(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.50)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'التواصل مع الدعم الفني',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),

            TriTextField(
              hint: 'عنوان المشكلة ',
              icon: Icons.subject_rounded,
              controller: subjectCtrl,
            ),
            const SizedBox(height: 10),
            TriTextField(
              hint: 'اكتب رسالتك هنا...',
              icon: Icons.chat_bubble_outline_rounded,
              controller: messageCtrl,
            ),
            const SizedBox(height: 14),

            GradientButton(
              text: 'إرسال',
              icon: Icons.send_rounded,
              filled: true,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال طلب الدعم ✅ (تجريبي)')),
                );
              },
            ),
            const SizedBox(height: 10),
            GradientButton(
              text: 'إلغاء',
              icon: Icons.close_rounded,
              filled: false,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}