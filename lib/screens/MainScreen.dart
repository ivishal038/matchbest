import 'package:flutter/material.dart';
import '../theme/gradient_background.dart';
import 'home_page.dart';
import 'blog_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    BlogScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Clamp icon size and font sizes
    double iconSize = (screenWidth * 0.07).clamp(24.0, 32.0); // Min 24, Max 32
    double selectedFontSize = (screenWidth * 0.035).clamp(12.0, 16.0);
    double unselectedFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screens[_currentIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              elevation: 0,
              iconSize: iconSize,
              selectedFontSize: selectedFontSize,
              unselectedFontSize: unselectedFontSize,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Blog',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'About',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
