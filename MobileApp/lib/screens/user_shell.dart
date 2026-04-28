import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';
import '../widgets/bottom_nav.dart';

import 'user_notifications_page.dart';
import 'user_profile_page.dart';
import 'user_settings_page.dart';

class UserShell extends StatefulWidget {
  final int initialIndex; // 0 إشعارات، 1 ملف شخصي، 2 إعدادات
  const UserShell({super.key, this.initialIndex = 0});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      UserNotificationsPage(),
      UserProfilePage(),
      UserSettingsPage(),
    ];

    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: IndexedStack(
            index: index,
            children: pages,
          ),
        ),
        bottomNavigationBar: TriBottomNav(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
        ),
      ),
    );
  }
} 