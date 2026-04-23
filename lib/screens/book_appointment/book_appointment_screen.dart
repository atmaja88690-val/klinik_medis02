import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0077B6),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Book Appointment Screen'),
      ),
    );
  }
}
