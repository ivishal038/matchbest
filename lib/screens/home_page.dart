import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/gradient_background.dart';
import '../widgets/banner_widget.dart';
import '../widgets/service_card_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'category_screen.dart';
import 'package:matchbest/provider/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, String>>> bannersFuture;
  late Future<List<Map<String, String>>> servicesFuture;
  late PageController _pageController;
  int _currentBannerPage = 0;

  @override
  void initState() {
    super.initState();
    bannersFuture = fetchBannersFromApi();
    servicesFuture = fetchServicesFromApi();
    _pageController = PageController();

    Future.delayed(Duration.zero, () {
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_pageController.hasClients && mounted) {
          setState(() {
            _currentBannerPage++;
            if (_currentBannerPage >= 9) _currentBannerPage = 0;
          });
          _pageController.animateToPage(
            _currentBannerPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Map<String, String>>> fetchBannersFromApi() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<String> bannerImages = [
      'assets/images/banner.png',
      'assets/images/banner1.png',
      'assets/images/banner2.png',
      'assets/images/banner3.png',
      'assets/images/banner4.png',
      'assets/images/banner5.png',
      'assets/images/banner6.png',
      'assets/images/banner7.png',
      'assets/images/banner8.png',
      // add only existing images here
    ];

    return bannerImages.map((path) => {
      'imageUrl': path,
      'buttonText': 'Explore More',
    }).toList();
  }


  Future<List<Map<String, String>>> fetchServicesFromApi() async {
    final response = await http.get(Uri.parse('$api/services'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Map<String, String>>((service) => {
        '_id': service['_id'].toString(),
        'title': service['title'] ?? '',
        'description': service['description'] ?? '',
        'imageUrl': service['imageUrl'] ?? '',
      }).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _launchPhoneDialer() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+918448149419');
    await launchUrl(launchUri);
  }

  void _launchLinkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/company/matchbestsoftwarepvtltd/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Welcome to MatchBest Softwares!",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.lightBlue, size: 22),
              onPressed: _launchPhoneDialer,
            ),
            GestureDetector(
              onTap: _launchLinkedIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Image.asset(
                  'assets/images/linkedin.png',
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Map<String, String>>>(
                future: bannersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading banners'));
                  } else {
                    final banners = snapshot.data!;
                    return SizedBox(
                      height: screenHeight * 0.3,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: banners.length,
                        itemBuilder: (context, index) {
                          final banner = banners[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            child: BannerWidget(
                              imageUrl: banner['imageUrl']!,
                              buttonText: banner['buttonText']!,
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                child: const Center(
                  child: Text(
                    'Services',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              FutureBuilder<List<Map<String, String>>>(
                future: servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading services'));
                  } else {
                    final services = snapshot.data!;

                    List<List<Map<String, String>>> servicePairs = [];
                    for (int i = 0; i < services.length; i += 2) {
                      int end = (i + 2 <= services.length) ? i + 2 : services.length;
                      servicePairs.add(services.sublist(i, end));
                    }

                    return SizedBox(
                      height: screenHeight * 0.6,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicePairs.length,
                        itemBuilder: (context, index) {
                          final pair = servicePairs[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                            child: SizedBox(
                              width: screenWidth * 0.5,
                              child: Column(
                                children: pair.map((service) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                                    child: SizedBox(
                                      height: screenHeight * 0.25,
                                      child: ServiceCardWidget(
                                        imageUrl: service['imageUrl']!,
                                        title: service['title']!,
                                        description: service['description']!,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CategoryScreen(
                                                serviceId: service['_id']!,
                                                serviceTitle: service['title']!,
                                                serviceImageUrl: service['imageUrl']!,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
