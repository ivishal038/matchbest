import 'package:flutter/material.dart';
import '../theme/gradient_background.dart';

class BlogDetailScreen extends StatelessWidget {
  final Map<String, dynamic> blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final sections = List<Map<String, dynamic>>.from(blog['sections'] ?? []);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.04;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            blog['department'] ?? '',
            style: TextStyle(fontSize: fontSize * 1.1),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Blog Title --
              Text(
                blog['title'] ?? '',
                style: TextStyle(fontSize: fontSize * 1.3, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.008),

              // -- Blog Date --
              Text(
                blog['date'] ?? '',
                style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.85),
              ),
              SizedBox(height: screenHeight * 0.02),

              // -- Blog Image --
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    blog['image'],
                    width: double.infinity,
                    height: screenHeight * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: screenWidth * 0.1),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // -- Blog Sections --
              ...sections.asMap().entries.map((entry) {
                int index = entry.key;
                final section = entry.value;

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (index * 150)),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Section Heading --
                      Text(
                        section['heading'] ?? '',
                        style: TextStyle(
                          fontSize: fontSize * 1.15,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // -- Paragraph --
                      Text(
                        section['paragraph'] ?? '',
                        style: TextStyle(fontSize: fontSize, height: 1.5),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // -- Bullet Points --
                      ...List<String>.from(section['bulletPoints'] ?? []).map((point) => Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.005),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: fontSize)),
                            Expanded(
                              child: Text(
                                point,
                                style: TextStyle(fontSize: fontSize, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: screenHeight * 0.025),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
