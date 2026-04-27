import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';
import 'attempts_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _search = TextEditingController();

  final List<_User> _users = [
    _User(
      name: "محمد علي",
      empId: "EMP-1021",
      active: true,
      email: "m.ali@triguard.com",
      phone: "05xxxxxxx",
    ),
    _User(
      name: "سارة خالد",
      empId: "EMP-2044",
      active: true,
      email: "s.khaled@triguard.com",
      phone: "05xxxxxxx",
    ),
    _User(
      name: "أحمد سمير",
      empId: "EMP-3301",
      active: false,
      email: "a.sameer@triguard.com",
      phone: "05xxxxxxx",
    ),
    _User(
      name: "رهف عمر",
      empId: "EMP-4470",
      active: true,
      email: "r.omar@triguard.com",
      phone: "05xxxxxxx",
    ),
  ];

  List<_User> get _filtered {
    final q = _search.text.trim();
    if (q.isEmpty) return _users;
    return _users.where((u) => u.name.contains(q) || u.empId.contains(q)).toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            children: [
              // Top bar
              Row(
                children: [
                  _IconGlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Users Management",
                    style: TextStyle(
                      color: Color(0xFF1B2A4A),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _IconGlassButton(
                    icon: Icons.person_add_alt_1_rounded,
                    onTap: () => _snack("إضافة مستخدم (لاحقًا)"),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search
              _Glass(
                insets: const EdgeInsets.all(14),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "بحث (اسم / رقم موظف)",
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.55),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Users list
              ..._filtered.map(
                (u) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _Glass(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _openUser(u),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.white.withOpacity(0.60),
                              child: const Icon(Icons.person_rounded, color: Color(0xFF1B2A4A)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u.name,
                                    style: const TextStyle(
                                      color: Color(0xFF1B2A4A),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    u.empId,
                                    style: TextStyle(
                                      color: const Color(0xFF1B2A4A).withOpacity(0.70),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _StatusPill(active: u.active),
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF1B2A4A)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUser(_User u) {
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
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withOpacity(0.60),
                      child: const Icon(Icons.person_rounded, color: Color(0xFF1B2A4A)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u.name,
                            style: const TextStyle(
                              color: Color(0xFF1B2A4A),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            u.empId,
                            style: TextStyle(
                              color: const Color(0xFF1B2A4A).withOpacity(0.70),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusPill(active: u.active),
                  ],
                ),

                const SizedBox(height: 12),

                _DetailLine(label: "Email", value: u.email),
                _DetailLine(label: "Phone", value: u.phone),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: u.active ? GradientBg.cPurple : GradientBg.cTurquoise,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          setState(() {
                            final i = _users.indexWhere((x) => x.empId == u.empId);
                            if (i != -1) _users[i] = _users[i].copyWith(active: !u.active);
                          });
                          Navigator.pop(context);
                        },
                        icon: Icon(u.active ? Icons.pause_circle_rounded : Icons.play_circle_rounded),
                        label: Text(
                          u.active ? "إيقاف الحساب" : "تفعيل الحساب",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1B2A4A),
                          side: BorderSide(color: GradientBg.cSky.withOpacity(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AttemptsPage()),
                          );
                        },
                        icon: const Icon(Icons.history_rounded),
                        label: const Text("عرض محاولاته", style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1B2A4A),
                    side: BorderSide(color: GradientBg.cPurple.withOpacity(0.35)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _resetPasswordSheet(u),
                  icon: const Icon(Icons.lock_reset_rounded),
                  label: const Text("إعادة تعيين كلمة المرور", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetPasswordSheet(_User u) {
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
                const Text(
                  "إعادة تعيين كلمة المرور",
                  style: TextStyle(
                    color: Color(0xFF1B2A4A),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "سيتم إرسال كلمة مرور مؤقتة للمستخدم: ${u.name}",
                  style: TextStyle(
                    color: const Color(0xFF1B2A4A).withOpacity(0.75),
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GradientBg.cTurquoise,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text("إرسال كلمة مؤقتة", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ---------- UI Helpers ----------

class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets insets;

  const _Glass({
    required this.child,
    this.insets = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: insets,
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

class _StatusPill extends StatelessWidget {
  final bool active;
  const _StatusPill({required this.active});

  @override
  Widget build(BuildContext context) {
    final c = active ? GradientBg.cTurquoise : GradientBg.cPurple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        active ? "نشط" : "موقوف",
        style: const TextStyle(
          color: Color(0xFF1B2A4A),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
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

// ---------- Model ----------

class _User {
  final String name;
  final String empId;
  final bool active;
  final String email;
  final String phone;

  _User({
    required this.name,
    required this.empId,
    required this.active,
    required this.email,
    required this.phone,
  });

  _User copyWith({bool? active}) => _User(
        name: name,
        empId: empId,
        active: active ?? this.active,
        email: email,
        phone: phone,
      );
}