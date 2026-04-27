import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';

import 'alerts_page.dart';
import 'attempts_page.dart';
import 'users_page.dart';
import 'devices_page.dart';
import 'settings_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية
    final recentEvents = const [
      _Event(title: "محاولة فاشلة", device: "بوابة 2 - المبنى A", time: "قبل 2 د", success: false),
      _Event(title: "نجاح تحقق", device: "بوابة 1 - المدخل", time: "قبل 9 د", success: true),
      _Event(title: "نشاط مشبوه", device: "بوابة 3 - قسم السيرفر", time: "قبل 16 د", success: false),
      _Event(title: "نجاح تحقق", device: "بوابة 1 - المدخل", time: "قبل 24 د", success: true),
    ];

    return Scaffold(
      body: GradientBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مرحبًا، أحمد",
                          style: TextStyle(
                            color: const Color(0xFF1B2A4A).withOpacity(0.85),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Dashboard",
                          style: const TextStyle(
                            color: Color(0xFF1B2A4A),
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _IconGlassButton(
                      icon: Icons.notifications_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AlertsPage()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _IconGlassButton(
                      icon: Icons.settings_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Summary cards (2x2)
                Row(
                  children: const [
                    Expanded(
                      child: _SummaryCard(
                        title: "تنبيهات جديدة",
                        value: "7",
                        icon: Icons.notification_important_rounded,
                        accent: GradientBg.cPurple,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: "محاولات فاشلة اليوم",
                        value: "14",
                        icon: Icons.block_rounded,
                        accent: GradientBg.cSky,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                      child: _SummaryCard(
                        title: "أجهزة غير متصلة",
                        value: "3",
                        icon: Icons.wifi_off_rounded,
                        accent: GradientBg.cTurquoise,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: "صحة النظام",
                        value: "99.9%",
                        icon: Icons.health_and_safety_rounded,
                        accent: Color(0xFF2BD4A6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Shortcuts
                _Glass(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "اختصارات",
                        style: TextStyle(
                          color: Color(0xFF1B2A4A),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _Shortcut(
                              label: "تنبيهات",
                              icon: Icons.notifications_active_rounded,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AlertsPage()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Shortcut(
                              label: "سجل",
                              icon: Icons.list_alt_rounded,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AttemptsPage()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Shortcut(
                              label: "مستخدمين",
                              icon: Icons.group_rounded,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const UsersPage()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Shortcut(
                              label: "أجهزة",
                              icon: Icons.router_rounded,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const DevicesPage()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Recent events (last 3-5)
                Expanded(
                  child: _Glass(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "آخر الأحداث",
                              style: TextStyle(
                                color: Color(0xFF1B2A4A),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AttemptsPage()),
                              ),
                              child: Text(
                                "عرض الكل",
                                style: TextStyle(
                                  color: GradientBg.cPurple.withOpacity(0.95),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...recentEvents.take(5).map((e) => _EventRow(event: e)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- UI Pieces ----------

class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _Glass({required this.child, this.padding = const EdgeInsets.all(16)});

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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return _Glass(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent.withOpacity(0.90), GradientBg.cSky.withOpacity(0.85), GradientBg.cTurquoise.withOpacity(0.85)],
              ),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1B2A4A).withOpacity(0.72),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1B2A4A),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _Shortcut({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.65)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1B2A4A)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1B2A4A),
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Event {
  final String title;
  final String device;
  final String time;
  final bool success;

  const _Event({
    required this.title,
    required this.device,
    required this.time,
    required this.success,
  });
}

class _EventRow extends StatelessWidget {
  final _Event event;

  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final icon = event.success ? Icons.check_circle_rounded : Icons.error_rounded;
    final c = event.success ? GradientBg.cTurquoise : GradientBg.cPurple;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, color: c.withOpacity(0.95)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Color(0xFF1B2A4A),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.device,
                  style: TextStyle(
                    color: const Color(0xFF1B2A4A).withOpacity(0.68),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event.time,
            style: TextStyle(
              color: const Color(0xFF1B2A4A).withOpacity(0.65),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}