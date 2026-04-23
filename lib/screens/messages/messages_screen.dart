import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0077B6),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Messages Screen'),
      ),
    );
  }
}
