import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl; // This will now be a path to asset
  final String buttonText;
  final VoidCallback onTap;

  const BannerWidget({
    super.key,
    required this.imageUrl,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imageUrl,
            width: screenWidth, // Full width of screen
            height: screenHeight * 0.30, // Adjusted for all screens (~28% of screen height)
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.07, // ~3% from bottom
          left: screenWidth * 0.04, // ~4% from left
          child: SizedBox(
            width: screenWidth * 0.30, // ~30% of screen width
            height: screenHeight * 0.04, // ~5.5% of screen height
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // make background transparent
                foregroundColor: Colors.purple.shade100, // text/icon color
                shadowColor: Colors.transparent, // remove shadow
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // dynamic horizontal padding
                  vertical: screenHeight * 0.012, // dynamic vertical padding
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.purple), // optional border
                ),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: screenWidth * 0.035, // dynamic font size ~3.5% of width
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
