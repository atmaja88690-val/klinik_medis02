import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/book_appointment/book_appointment_screen.dart';
import 'screens/health/health_screen.dart';

class BSIHealthApp extends StatelessWidget {
  const BSIHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BSI Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0077B6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0077B6)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0077B6),
          elevation: 0,
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const MessagesScreen(),
      const BookAppointmentScreen(),
      const HealthScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0077B6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
        ],
      ),
    );
  }
}