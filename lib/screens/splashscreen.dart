import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first_time') ?? true;

    await Future.delayed(const Duration(seconds: 3));

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset('assets/images/logo.png', // ensure path is correct
                width: screenWidth * 0.35, // ~35% of screen width
                height: screenWidth * 0.35,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.015), // dynamic spacing ~1.5% of height
            Text.rich(
              TextSpan(
                text: 'MATCH',
                style: TextStyle(
                  fontSize: screenWidth * 0.065, // ~6.5% of width
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'BEST',
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // ~1% spacing
            Text(
              'SOFTWARE PVT.LTD.',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // ~4% of width
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
