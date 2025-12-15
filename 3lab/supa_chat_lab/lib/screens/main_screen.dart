import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'registration_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _pages = const [
    AuthScreen(),
    RegistrationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Авторизация',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Регистрация',
          ),
        ],
      ),
    );
  }
}
