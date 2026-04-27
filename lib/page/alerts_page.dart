import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import 'attempts_page.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  int filterIndex = 0; // 0: New, 1: Handled, 2: All

  final List<_AlertItem> _items = [
    _AlertItem(
      id: "AL-1001",
      type: "فشل تحقق",
      time: "قبل 6 د",
      severity: _Severity.high,
      isNew: true,
      device: "بوابة 2",
      user: "محمد علي",
      note: "عدم تطابق الصوت بعد 3 محاولات متتالية.",
      relatedAttemptId: "AT-2001",
    ),
    _AlertItem(
      id: "AL-1002",
      type: "نشاط مشبوه",
      time: "قبل 14 د",
      severity: _Severity.high,
      isNew: true,
      device: "بوابة 3",
      user: "غير معروف",
      note: "محاولة دخول متعددة من نفس الجهاز خلال فترة قصيرة.",
      relatedAttemptId: "AT-2002",
    ),
    _AlertItem(
      id: "AL-1003",
      type: "انقطاع جهاز",
      time: "قبل 40 د",
      severity: _Severity.medium,
      isNew: true,
      device: "بوابة 1",
      user: "-",
      note: "انقطاع اتصال بوابة 1 عن الشبكة.",
      relatedAttemptId: "",
    ),
    _AlertItem(
      id: "AL-1004",
      type: "فشل ECG",
      time: "أمس",
      severity: _Severity.medium,
      isNew: false,
      device: "بوابة 4",
      user: "أحمد سمير",
      note: "ECG غير مطابق لقالب المستخدم.",
      relatedAttemptId: "AT-2008",
    ),
    _AlertItem(
      id: "AL-1005",
      type: "فشل صوت",
      time: "أمس",
      severity: _Severity.low,
      isNew: false,
      device: "بوابة 2",
      user: "سارة خالد",
      note: "انخفاض جودة الصوت بسبب ضوضاء عالية.",
      relatedAttemptId: "AT-2010",
    ),
  ];

  List<_AlertItem> get _filtered {
    if (filterIndex == 0) return _items.where((e) => e.isNew).toList();
    if (filterIndex == 1) return _items.where((e) => !e.isNew).toList();
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            children: [
              // Top
              Row(
                children: [
                  _IconGlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Alerts Center",
                    style: TextStyle(
                      color: Color(0xFF1B2A4A),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _IconGlassButton(
                    icon: Icons.refresh_rounded,
                    onTap: () => setState(() {}),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Filters
              _Glass(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: _FilterTab(
                        text: "جديدة",
                        selected: filterIndex == 0,
                        onTap: () => setState(() => filterIndex = 0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _FilterTab(
                        text: "تمت معالجتها",
                        selected: filterIndex == 1,
                        onTap: () => setState(() => filterIndex = 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _FilterTab(
                        text: "الكل",
                        selected: filterIndex == 2,
                        onTap: () => setState(() => filterIndex = 2),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Alerts list
              ..._filtered.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _Glass(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _openDetails(a),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              _AlertIcon(type: a.type),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          a.type,
                                          style: const TextStyle(
                                            color: Color(0xFF1B2A4A),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15.5,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (a.isNew) const _MiniChip(text: "New", icon: Icons.fiber_new_rounded),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${a.device} • ${a.user}",
                                      style: TextStyle(
                                        color: const Color(0xFF1B2A4A).withOpacity(0.70),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _SeverityBadge(severity: a.severity),
                                        const Spacer(),
                                        Text(
                                          a.time,
                                          style: TextStyle(
                                            color: const Color(0xFF1B2A4A).withOpacity(0.65),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right_rounded, color: Color(0xFF1B2A4A)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetails(_AlertItem a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
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

                Text(
                  a.type,
                  style: const TextStyle(
                    color: Color(0xFF1B2A4A),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    _SeverityBadge(severity: a.severity),
                    const SizedBox(width: 10),
                    Text(
                      a.time,
                      style: TextStyle(
                        color: const Color(0xFF1B2A4A).withOpacity(0.72),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (a.isNew) const _MiniChip(text: "New", icon: Icons.fiber_new_rounded),
                  ],
                ),

                const SizedBox(height: 12),

                _DetailLine(label: "المستخدم", value: a.user),
                _DetailLine(label: "الجهاز", value: a.device),
                _DetailLine(label: "رقم التنبيه", value: a.id),
                const SizedBox(height: 10),

                _Glass(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_rounded, color: GradientBg.cSky.withOpacity(0.95)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          a.note,
                          style: TextStyle(
                            color: const Color(0xFF1B2A4A).withOpacity(0.78),
                            fontWeight: FontWeight.w800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GradientBg.cTurquoise,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          setState(() {
                            final idx = _items.indexWhere((x) => x.id == a.id);
                            if (idx != -1) _items[idx] = _items[idx].copyWith(isNew: false);
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: const Text("تمت المعالجة", style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1B2A4A),
                          side: BorderSide(color: GradientBg.cPurple.withOpacity(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: a.relatedAttemptId.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AttemptsPage(openAttemptId: a.relatedAttemptId),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text("عرض المحاولة", style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------- Models & UI -----------------

class _AlertItem {
  final String id;
  final String type;
  final String time;
  final _Severity severity;
  final bool isNew;
  final String device;
  final String user;
  final String note;
  final String relatedAttemptId;

  const _AlertItem({
    required this.id,
    required this.type,
    required this.time,
    required this.severity,
    required this.isNew,
    required this.device,
    required this.user,
    required this.note,
    required this.relatedAttemptId,
  });

  _AlertItem copyWith({bool? isNew}) {
    return _AlertItem(
      id: id,
      type: type,
      time: time,
      severity: severity,
      isNew: isNew ?? this.isNew,
      device: device,
      user: user,
      note: note,
      relatedAttemptId: relatedAttemptId,
    );
  }
}

enum _Severity { low, medium, high }

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

class _FilterTab extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTab({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? GradientBg.cSky.withOpacity(0.25) : Colors.white.withOpacity(0.55),
          border: Border.all(color: Colors.white.withOpacity(0.65)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1B2A4A),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _MiniChip({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.65)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1B2A4A).withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1B2A4A),
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final _Severity severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    String t;
    Color c;

    switch (severity) {
      case _Severity.low:
        t = "منخفض";
        c = GradientBg.cTurquoise;
        break;
      case _Severity.medium:
        t = "متوسط";
        c = GradientBg.cSky;
        break;
      case _Severity.high:
        t = "عالي";
        c = GradientBg.cPurple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        t,
        style: const TextStyle(
          color: Color(0xFF1B2A4A),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  final String type;
  const _AlertIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (type.contains("انقطاع")) {
      icon = Icons.wifi_off_rounded;
    } else if (type.contains("مشبوه")) {
      icon = Icons.shield_rounded;
    } else {
      icon = Icons.warning_rounded;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GradientBg.cTurquoise, GradientBg.cSky, GradientBg.cPurple],
        ),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF1B2A4A).withOpacity(0.70),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1B2A4A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}