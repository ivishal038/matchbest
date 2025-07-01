import 'package:flutter/material.dart';
import '../theme/gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  void _launchPhoneDialer() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+918448149419');
    await launchUrl(launchUri);
  }


  @override
  Widget build(BuildContext context) {
    final slideTween = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.045;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('About Us')),
        body: FadeTransition(
          opacity: _fadeController,
          child: SlideTransition(
            position: slideTween.animate(CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOut,
            )),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- Header Image --
                  Hero(
                    tag: 'aboutHeader',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/about_header.png',
                        height: screenHeight * 0.3,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // -- Who We Are --
                  _buildSectionTitle('Who We Are', fontSize * 1.2),
                  SizedBox(height: screenHeight * 0.01),
                  _buildDescriptionText(
                    'At Matchbest Software, we are a dynamic IT services and system integration firm specializing in IT consulting and application development. Our expertise spans NOC/SOC management, system integration, and product development, ensuring robust and secure technological solutions. With a strong focus on media and OTT platforms, we deliver scalable, high-performance applications that meet the evolving demands of the digital landscape. Our commitment to innovation and excellence drives us to create cutting-edge solutions that empower businesses to thrive in an ever-changing tech ecosystem.',
                    fontSize,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // -- Mission Card --
                  _buildCard(
                    title: 'Our Mission',
                    content:
                    'We aim to deliver reliable and scalable IT solutions that empower businesses to stay ahead in a fast-evolving digital landscape. With a team of skilled professionals, we deliver customized, scalable, and secure IT services tailored to your needs. Our commitment to quality, transparency, and client success sets us apart in the industry.',
                    fontSize: fontSize,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // -- Why Choose Us --
                  _buildSectionTitle('Why Choose Us', fontSize * 1.2),
                  SizedBox(height: screenHeight * 0.02),
                  _buildReasonTile(Icons.engineering, 'Industry Expertise',
                      'Our team has hands‑on experience in IT services, ensuring reliable and innovative solutions.', fontSize),
                  _buildReasonTile(Icons.settings, 'Tailored Solutions',
                      'We design customized IT strategies that align with your business goals and operational needs.', fontSize),
                  _buildReasonTile(Icons.support_agent, 'End-to-End Support',
                      'From consultation to implementation, we provide seamless IT solutions with continuous support.', fontSize),
                  _buildReasonTile(Icons.verified, 'Commitment to Quality',
                      'We prioritize efficiency, security, and scalability to deliver high‑quality IT services for long‑term success.', fontSize),

                  SizedBox(height: screenHeight * 0.03),

                  // -- Our Core Values --
                  _buildSectionTitle('Our Core Values', fontSize * 1.2),
                  SizedBox(height: screenHeight * 0.02),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildValueCard('Innovation', 'Staying updated with the latest technology trends', fontSize, screenWidth),
                      _buildValueCard('Transparency', 'Clear communication and ethical business practices', fontSize, screenWidth),
                      _buildValueCard('Commitment', 'Dedicated to delivering high-quality IT services', fontSize, screenWidth),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // -- Get in Touch --
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchPhoneDialer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 6,
                      ),
                      child: Text('Contact Us', style: TextStyle(fontSize: fontSize)),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double fontSize) {
    return Center(
      child: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDescriptionText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, height: 1.5),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildCard({required String title, required String content, required double fontSize}) {
    return Container(
      padding: EdgeInsets.all(fontSize),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: fontSize * 1.2, fontWeight: FontWeight.bold)),
          SizedBox(height: fontSize * 0.6),
          Text(content, style: TextStyle(fontSize: fontSize, height: 1.4), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildReasonTile(IconData icon, String title, String description, double fontSize) {
    return Container(
      margin: EdgeInsets.only(bottom: fontSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple, size: fontSize * 1.5),
          SizedBox(width: fontSize * 0.6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: fontSize * 1.05, fontWeight: FontWeight.bold)),
                SizedBox(height: fontSize * 0.3),
                Text(description, style: TextStyle(fontSize: fontSize * 0.95, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(String title, String subtitle, double fontSize, double screenWidth) {
    return Container(
      width: (screenWidth - 60) / 2,
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
          SizedBox(height: fontSize * 0.4),
          Text(subtitle, style: TextStyle(fontSize: fontSize * 0.9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
