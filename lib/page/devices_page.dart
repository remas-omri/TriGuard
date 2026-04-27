import 'package:flutter/material.dart';
import '../widgets/gradient_bg.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final List<_Device> _devices = [
    _Device(id: "DV-01", name: "بوابة 1", location: "المدخل الرئيسي", online: true, enabled: true),
    _Device(id: "DV-02", name: "بوابة 2", location: "المبنى A - الدور 2", online: false, enabled: true),
    _Device(id: "DV-03", name: "بوابة 3", location: "قسم السيرفر", online: true, enabled: true),
    _Device(id: "DV-04", name: "بوابة 4", location: "المخزن", online: true, enabled: false),
  ];

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
                    "Devices Management",
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

              // List
              ..._devices.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _Glass(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _openDevice(d),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              _DeviceIcon(online: d.online),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          d.name,
                                          style: const TextStyle(
                                            color: Color(0xFF1B2A4A),
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          d.id,
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
                                      d.location,
                                      style: TextStyle(
                                        color: const Color(0xFF1B2A4A).withOpacity(0.70),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _ConnPill(online: d.online),
                                        const SizedBox(width: 8),
                                        _EnablePill(enabled: d.enabled),
                                      ],
                                    )
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

  void _openDevice(_Device d) {
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
                    _DeviceIcon(online: d.online),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            style: const TextStyle(
                              color: Color(0xFF1B2A4A),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.id,
                            style: TextStyle(
                              color: const Color(0xFF1B2A4A).withOpacity(0.70),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ConnPill(online: d.online),
                  ],
                ),

                const SizedBox(height: 12),

                _DetailLine(label: "الموقع", value: d.location),
                _DetailLine(label: "الحالة", value: d.online ? "متصل" : "غير متصل"),
                _DetailLine(label: "التفعيل", value: d.enabled ? "مفعّل" : "موقوف"),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: d.enabled ? GradientBg.cPurple : GradientBg.cTurquoise,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          setState(() {
                            final idx = _devices.indexWhere((x) => x.id == d.id);
                            if (idx != -1) _devices[idx] = _devices[idx].copyWith(enabled: !d.enabled);
                          });
                          Navigator.pop(context);
                        },
                        icon: Icon(d.enabled ? Icons.pause_circle_rounded : Icons.play_circle_rounded),
                        label: Text(
                          d.enabled ? "إيقاف الجهاز" : "تفعيل الجهاز",
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
                          _snack("سجل الجهاز (لاحقًا نربطه بقاعدة البيانات)");
                        },
                        icon: const Icon(Icons.list_alt_rounded),
                        label: const Text("سجل الجهاز", style: TextStyle(fontWeight: FontWeight.w900)),
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

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

class _DeviceIcon extends StatelessWidget {
  final bool online;
  const _DeviceIcon({required this.online});

  @override
  Widget build(BuildContext context) {
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
      child: Icon(
        online ? Icons.router_rounded : Icons.portable_wifi_off_rounded,
        color: Colors.white,
      ),
    );
  }
}

class _ConnPill extends StatelessWidget {
  final bool online;
  const _ConnPill({required this.online});

  @override
  Widget build(BuildContext context) {
    final c = online ? GradientBg.cTurquoise : GradientBg.cPurple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        online ? "متصل" : "غير متصل",
        style: const TextStyle(
          color: Color(0xFF1B2A4A),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _EnablePill extends StatelessWidget {
  final bool enabled;
  const _EnablePill({required this.enabled});

  @override
  Widget build(BuildContext context) {
    final c = enabled ? GradientBg.cSky : GradientBg.cPurple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        enabled ? "مفعّل" : "موقوف",
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

class _Device {
  final String id;
  final String name;
  final String location;
  final bool online;
  final bool enabled;

  const _Device({
    required this.id,
    required this.name,
    required this.location,
    required this.online,
    required this.enabled,
  });

  _Device copyWith({bool? enabled}) => _Device(
        id: id,
        name: name,
        location: location,
        online: online,
        enabled: enabled ?? this.enabled,
      );
} 