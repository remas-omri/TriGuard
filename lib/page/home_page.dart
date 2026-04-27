import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';

class HomePage extends StatelessWidget {
  final bool isAdmin;
  const HomePage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.65)),
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFF1B2A4A)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isAdmin ? "لوحة التحكم" : "الرئيسية",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B2A4A),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.60),
                    child: const Icon(Icons.person_rounded, color: Color(0xFF1B2A4A)),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              _StatCard(
                leftTitle: "صحة النظام",
                leftValue: "99.9",
                leftSub: "مستقر بالكامل",
                rightTitle: "المستخدمون",
                rightValue: "1,284",
                rightSub: "نشط اليوم 216",
              ),

              const SizedBox(height: 18),

              // Quick actions placeholder
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.65)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAdmin ? "إجراءات المسؤول" : "إجراءات سريعة",
                        style: const TextStyle(
                          color: Color(0xFF1B2A4A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isAdmin
                            ? "• عرض التنبيهات\n• سجلات الدخول\n• إدارة الأجهزة\n• إدارة الصلاحيات"
                            : "• آخر محاولات الدخول\n• إشعارات الأمان\n• بدء تحقق حيوي",
                        style: TextStyle(
                          color: const Color(0xFF1B2A4A).withOpacity(0.75),
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "تسجيل خروج",
                            style: TextStyle(
                              color: GradientBg.cPurple.withOpacity(0.95),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String leftTitle, leftValue, leftSub;
  final String rightTitle, rightValue, rightSub;

  const _StatCard({
    required this.leftTitle,
    required this.leftValue,
    required this.leftSub,
    required this.rightTitle,
    required this.rightValue,
    required this.rightSub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              icon: Icons.health_and_safety_rounded,
              title: leftTitle,
              value: leftValue,
              sub: leftSub,
            ),
          ),
          Container(width: 1, height: 70, color: Colors.white.withOpacity(0.75)),
          Expanded(
            child: _Stat(
              icon: Icons.group_rounded,
              title: rightTitle,
              value: rightValue,
              sub: rightSub,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String title, value, sub;

  const _Stat({required this.icon, required this.title, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: GradientBg.cTurquoise),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF1B2A4A), fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Color(0xFF1B2A4A), fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(color: const Color(0xFF1B2A4A).withOpacity(0.70), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}