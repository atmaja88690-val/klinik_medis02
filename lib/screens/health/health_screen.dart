import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0077B6),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Health Screen'),
      ),
    );
  }
}
