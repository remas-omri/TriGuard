import 'package:flutter/material.dart';
import '../widgets/tri_widgets.dart';

class AdminHomeDummy extends StatelessWidget {
  const AdminHomeDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return TriBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Text('لوحة تحكم المدير (Placeholder)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}