import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';

class AttemptsPage extends StatefulWidget {
  final String? openAttemptId; // لو جاي من Alerts يفتحها تلقائيًا
  const AttemptsPage({super.key, this.openAttemptId});

  @override
  State<AttemptsPage> createState() => _AttemptsPageState();
}

class _AttemptsPageState extends State<AttemptsPage> {
  final TextEditingController _search = TextEditingController();

  bool failedOnly = false;
  bool todayOnly = true;
  String deviceFilter = "الكل";

  final List<_Attempt> _all = const [
    _Attempt(
      id: "AT-2001",
      user: "محمد علي",
      device: "بوابة 2",
      time: "اليوم 10:21",
      success: false,
      faceOk: true,
      voiceOk: false,
      ecgOk: false,
      failReason: "عدم تطابق الصوت",
    ),
    _Attempt(
      id: "AT-2002",
      user: "غير معروف",
      device: "بوابة 3",
      time: "اليوم 09:31",
      success: false,
      faceOk: false,
      voiceOk: false,
      ecgOk: false,
      failReason: "محاولة متكررة + بصمات غير صالحة",
    ),
    _Attempt(
      id: "AT-2003",
      user: "سارة خالد",
      device: "بوابة 1",
      time: "اليوم 09:55",
      success: true,
      faceOk: true,
      voiceOk: true,
      ecgOk: true,
      failReason: "",
    ),
    _Attempt(
      id: "AT-2008",
      user: "أحمد سمير",
      device: "بوابة 4",
      time: "أمس 21:12",
      success: false,
      faceOk: true,
      voiceOk: true,
      ecgOk: false,
      failReason: "ECG غير مطابق",
    ),
    _Attempt(
      id: "AT-2010",
      user: "سارة خالد",
      device: "بوابة 2",
      time: "أمس 18:02",
      success: false,
      faceOk: true,
      voiceOk: false,
      ecgOk: true,
      failReason: "ضوضاء عالية أثرت على الصوت",
    ),
  ];

  List<String> get _devices => const ["الكل", "بوابة 1", "بوابة 2", "بوابة 3", "بوابة 4"];

  @override
  void initState() {
    super.initState();

    // فتح التفاصيل تلقائيًا إذا جاء openAttemptId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.openAttemptId;
      if (id == null || id.isEmpty) return;
      final found = _all.where((a) => a.id == id).toList();
      if (found.isEmpty) return;
      _openDetails(found.first);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_Attempt> get _filtered {
    final q = _search.text.trim();

    return _all.where((a) {
      if (failedOnly && a.success) return false;
      if (todayOnly && !a.time.startsWith("اليوم")) return false;
      if (deviceFilter != "الكل" && a.device != deviceFilter) return false;

      if (q.isEmpty) return true;
      return a.user.contains(q) || a.device.contains(q) || a.id.contains(q);
    }).toList();
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
                    "Access Logs",
                    style: TextStyle(
                      color: Color(0xFF1B2A4A),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _IconGlassButton(icon: Icons.tune_rounded, onTap: () {}),
                ],
              ),
              const SizedBox(height: 14),

              // Search + Filters
              _Glass(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "بحث (اسم / جهاز / رقم المحاولة)",
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.55),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ToggleBox(
                            text: "فاشلة فقط",
                            value: failedOnly,
                            onChanged: (v) => setState(() => failedOnly = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ToggleBox(
                            text: "اليوم فقط",
                            value: todayOnly,
                            onChanged: (v) => setState(() => todayOnly = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.router_rounded, color: Color(0xFF1B2A4A)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.65)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: deviceFilter,
                                items: _devices
                                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                    .toList(),
                                onChanged: (v) => setState(() => deviceFilter = v ?? "الكل"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // List
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
                              Icon(
                                a.success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                color: a.success ? GradientBg.cTurquoise : GradientBg.cPurple,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          a.user,
                                          style: const TextStyle(
                                            color: Color(0xFF1B2A4A),
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          a.id,
                                          style: TextStyle(
                                            color: const Color(0xFF1B2A4A).withOpacity(0.65),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${a.device} • ${a.time}",
                                      style: TextStyle(
                                        color: const Color(0xFF1B2A4A).withOpacity(0.70),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (!a.success && a.failReason.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        "سبب الفشل: ${a.failReason}",
                                        style: TextStyle(
                                          color: const Color(0xFF1B2A4A).withOpacity(0.82),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
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

  void _openDetails(_Attempt a) {
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

                Row(
                  children: [
                    Icon(
                      a.success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: a.success ? GradientBg.cTurquoise : GradientBg.cPurple,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        a.success ? "نتيجة المحاولة: نجاح" : "نتيجة المحاولة: فشل",
                        style: const TextStyle(
                          color: Color(0xFF1B2A4A),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _DetailLine(label: "رقم المحاولة", value: a.id),
                _DetailLine(label: "المستخدم", value: a.user),
                _DetailLine(label: "الجهاز", value: a.device),
                _DetailLine(label: "الوقت", value: a.time),

                const SizedBox(height: 12),

                _Glass(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "نتيجة التحقق الحيوي",
                        style: TextStyle(
                          color: Color(0xFF1B2A4A),
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _BioResult(title: "وجه", ok: a.faceOk)),
                          Expanded(child: _BioResult(title: "صوت", ok: a.voiceOk)),
                          Expanded(child: _BioResult(title: "ECG", ok: a.ecgOk)),
                        ],
                      ),
                    ],
                  ),
                ),

                if (!a.success && a.failReason.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _Glass(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline_rounded, color: GradientBg.cPurple.withOpacity(0.95)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "سبب الفشل: ${a.failReason}",
                            style: TextStyle(
                              color: const Color(0xFF1B2A4A).withOpacity(0.85),
                              fontWeight: FontWeight.w800,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // زر إجراء (اختياري)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1B2A4A),
                          side: BorderSide(color: GradientBg.cSky.withOpacity(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.done_rounded),
                        label: const Text("إغلاق", style: TextStyle(fontWeight: FontWeight.w900)),
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

// ---------------- UI Helpers ----------------

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

class _ToggleBox extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleBox({required this.text, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.65)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1B2A4A),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: GradientBg.cTurquoise,
          ),
        ],
      ),
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

class _BioResult extends StatelessWidget {
  final String title;
  final bool ok;

  const _BioResult({required this.title, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          ok ? Icons.check_rounded : Icons.close_rounded,
          color: ok ? GradientBg.cTurquoise : GradientBg.cPurple,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1B2A4A),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ---------------- Model ----------------

class _Attempt {
  final String id;
  final String user;
  final String device;
  final String time;
  final bool success;
  final bool faceOk;
  final bool voiceOk;
  final bool ecgOk;
  final String failReason;

  const _Attempt({
    required this.id,
    required this.user,
    required this.device,
    required this.time,
    required this.success,
    required this.faceOk,
    required this.voiceOk,
    required this.ecgOk,
    required this.failReason,
  });
}