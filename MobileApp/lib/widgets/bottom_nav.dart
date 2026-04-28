import 'dart:ui';
import 'package:flutter/material.dart';

class TriBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TriBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.70),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFF6A7BFF), // لون من الشعار
              unselectedItemColor: Colors.black54,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none_rounded),
                  label: 'الإشعارات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'الملف الشخصي',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'الإعدادات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 