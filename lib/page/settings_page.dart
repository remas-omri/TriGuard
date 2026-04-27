import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushAlerts = true;
  bool emailAlerts = false;
  bool criticalOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            children: [
              Row(
                children: [
                  _IconGlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      color: Color(0xFF1B2A4A),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _IconGlassButton(icon: Icons.person_rounded, onTap: () {}),
                ],
              ),
              const SizedBox(height: 14),

              _Glass(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "الحساب",
                      style: TextStyle(
                        color: Color(0xFF1B2A4A),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _Item(
                      icon: Icons.lock_rounded,
                      title: "تغيير كلمة المرور",
                      subtitle: "تحديث كلمة المرور للحماية",
                      onTap: () => _changePasswordSheet(),
                    ),
                    const SizedBox(height: 10),
                    _Item(
                      icon: Icons.logout_rounded,
                      title: "تسجيل خروج",
                      subtitle: "الخروج من حساب الأدمن",
                      onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _Glass(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "إعدادات التنبيهات",
                      style: TextStyle(
                        color: Color(0xFF1B2A4A),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SwitchItem(
                      icon: Icons.notifications_active_rounded,
                      title: "تنبيهات Push",
                      value: pushAlerts,
                      onChanged: (v) => setState(() => pushAlerts = v),
                    ),
                    _SwitchItem(
                      icon: Icons.email_rounded,
                      title: "تنبيهات Email",
                      value: emailAlerts,
                      onChanged: (v) => setState(() => emailAlerts = v),
                    ),
                    _SwitchItem(
                      icon: Icons.priority_high_rounded,
                      title: "تنبيهات الحرجة فقط",
                      value: criticalOnly,
                      onChanged: (v) => setState(() => criticalOnly = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePasswordSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              border: Border.all(color: Colors.white.withOpacity(0.78)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "تغيير كلمة المرور",
                    style: TextStyle(
                      color: Color(0xFF1B2A4A),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PwdField(hint: "كلمة المرور الحالية", icon: Icons.lock_outline_rounded),
                  const SizedBox(height: 10),
                  _PwdField(hint: "كلمة مرور جديدة", icon: Icons.lock_rounded),
                  const SizedBox(height: 10),
                  _PwdField(hint: "تأكيد كلمة المرور", icon: Icons.check_rounded),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GradientBg.cTurquoise,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text("حفظ", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------- UI Helpers ----------

class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _Glass({required this.child, this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.56),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.56),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.65)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF1B2A4A)),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Item({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.65)),
              ),
              child: Icon(icon, color: const Color(0xFF1B2A4A)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF1B2A4A), fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: const Color(0xFF1B2A4A).withOpacity(0.70), fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF1B2A4A)),
          ],
        ),
      ),
    );
  }
}

class _SwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchItem({required this.icon, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1B2A4A)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF1B2A4A), fontWeight: FontWeight.w900))),
          Switch(value: value, onChanged: onChanged, activeColor: GradientBg.cTurquoise),
        ],
      ),
    );
  }
}

class _PwdField extends StatelessWidget {
  final String hint;
  final IconData icon;
  const _PwdField({required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(0.55),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}