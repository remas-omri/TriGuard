import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

enum AlertStatus { newAlert, reviewed }
enum AlertType { failed, suspicious }

class UserAlertItem {
  final AlertType type;
  final AlertStatus status;
  final String title;
  final String subtitle;
  final String location;
  final String timeAgo;

  const UserAlertItem({
    required this.type,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.timeAgo,
  });
}

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  String filter = 'الكل';

  // بيانات تجريبية (لاحقًا تربطينها من DB/API)
  final List<UserAlertItem> allAlerts = const [
    UserAlertItem(
      type: AlertType.failed,
      status: AlertStatus.newAlert,
      title: 'فشل تحقق',
      subtitle: 'Verification Failed',
      location: 'المدخل الرئيسي',
      timeAgo: 'قبل دقيقتين',
    ),
    UserAlertItem(
      type: AlertType.suspicious,
      status: AlertStatus.newAlert,
      title: 'محاولة دخول غير طبيعية',
      subtitle: 'Suspicious Attempt',
      location: 'البوابة الجانبية',
      timeAgo: 'قبل 8 دقائق',
    ),
    UserAlertItem(
      type: AlertType.failed,
      status: AlertStatus.reviewed,
      title: 'فشل تحقق',
      subtitle: 'Verification Failed',
      location: 'غرفة السيرفر',
      timeAgo: 'قبل 35 دقيقة',
    ),
  ];

  List<UserAlertItem> get filtered {
    if (filter == 'جديد') {
      return allAlerts.where((a) => a.status == AlertStatus.newAlert).toList();
    }
    if (filter == 'تمت المراجعة') {
      return allAlerts.where((a) => a.status == AlertStatus.reviewed).toList();
    }
    return allAlerts;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Center(child: TriLogo(size: 70)),
          const SizedBox(height: 10),

          const Text(
            'الإشعارات',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'تنبيهات مرتبطة بحسابك مثل فشل التحقق أو محاولة دخول غير طبيعية.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: Colors.black.withOpacity(0.55)),
          ),
          const SizedBox(height: 14),

          // فلاتر
          Row(
            children: [
              _FilterChip(
                label: 'الكل',
                active: filter == 'الكل',
                onTap: () => setState(() => filter = 'الكل'),
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'جديد',
                active: filter == 'جديد',
                onTap: () => setState(() => filter = 'جديد'),
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'تمت المراجعة',
                active: filter == 'تمت المراجعة',
                onTap: () => setState(() => filter = 'تمت المراجعة'),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _AlertCard(item: filtered[i]),
            ),
          ),

          const SizedBox(height: 10),
          const FooterPill(text: 'TriGuard | إشعارات فورية لحماية حسابك'),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: active ? Colors.white.withOpacity(0.75) : Colors.white.withOpacity(0.45),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.8,
            fontWeight: FontWeight.w800,
            color: active ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final UserAlertItem item;
  const _AlertCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isFailed = item.type == AlertType.failed;
    final Color tint = isFailed ? const Color(0xFFDC2626) : const Color(0xFFF59E0B);
    final IconData icon = isFailed ? Icons.close_rounded : Icons.warning_amber_rounded;

    final bool isNew = item.status == AlertStatus.newAlert;
    final String statusLabel = isNew ? 'جديد' : 'تمت المراجعة';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
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
          // مؤشر جديد/مراجعة
          Icon(
            isNew ? Icons.circle : Icons.check_circle,
            size: 18,
            color: isNew ? const Color(0xFF2563EB) : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 14.8, fontWeight: FontWeight.w900),
                      ),
                    ),
                    _StatusPill(text: statusLabel, active: isNew),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.55)),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.location}  •  ${item.timeAgo}',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black.withOpacity(0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final bool active;

  const _StatusPill({required this.text, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: active
            ? const Color(0xFF2563EB).withOpacity(0.12)
            : Colors.black.withOpacity(0.06),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          color: active ? const Color(0xFF2563EB) : Colors.black54,
        ),
      ),
    );
  }
} 