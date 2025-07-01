import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/gradient_background.dart';
import 'MainScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];

  final List<String> _texts = [
    'We aim to deliver reliable and scalable IT solutions.',
    'Our team builds high-performing apps for your growth.',
    'Get the best IT consultation for your business success.',
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView.builder(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _images[index],
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.45,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    _texts[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.055, // ~5.5% of width
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == _images.length - 1) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.withOpacity(0.75),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.15,
                        vertical: screenHeight * 0.018,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentIndex == _images.length - 1 ? "Get Started" : "Next",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // ~4.5% of width
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
