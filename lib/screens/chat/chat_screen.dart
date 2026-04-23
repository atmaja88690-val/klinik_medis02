import 'package:flutter/material.dart';

/// ChatScreen - Halaman chat untuk berkomunikasi dengan staf klinik
///
/// Widget ini menampilkan interface chat sederhana untuk menghubungi staf BSI Clinic.
///
/// Lokasi: lib/screens/chat/chat_screen.dart
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Us'),
        backgroundColor: const Color(0xFF0077B6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Color(0xFF0077B6),
            ),
            SizedBox(height: 16),
            Text(
              'Chat dengan Staf BSI Clinic',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fitur chat akan segera tersedia',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
