import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/feed/presentation/feed_screen.dart';
import 'package:flutter_application_1/features/home/presentation/home_screen.dart';
import 'package:flutter_application_1/features/services/presentation/services_screen.dart';
import 'package:flutter_application_1/features/settings/settings_screen.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FeedScreen(),
    const ServicesScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.book, color: Colors.green),
      label: 'Записи',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart, color: Colors.green),
      label: 'График',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add, color: Colors.green),
      label: 'Добавить',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings, color: Colors.green),
      label: 'Настройки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavBarItems,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.purple.shade300,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
