import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class UserHomeDummy extends StatelessWidget {
  const UserHomeDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Text('واجهة المستخدم (Placeholder)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}