import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:matchbest/provider/api.dart';
import '../theme/gradient_background.dart';

class ItemDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String serviceTitle;

  const ItemDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.serviceTitle,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<Map<String, dynamic>> itemFuture;

  @override
  void initState() {
    super.initState();
    itemFuture = fetchItem(widget.categoryId);
  }

  Future<Map<String, dynamic>> fetchItem(String categoryId) async {
    final response = await http.get(Uri.parse('$api/items/$categoryId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.first as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load item');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.serviceTitle} / ${widget.categoryTitle}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: itemFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading item'));
            } else {
              final item = snapshot.data!;
              final description = item['description'] ?? '';
              final images = List<String>.from(item['images'] ?? []);
              final options = List<Map<String, dynamic>>.from(item['options'] ?? []);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Description Section --
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(screenWidth * 0.04),
                          bottomRight: Radius.circular(screenWidth * 0.04),
                        ),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: screenWidth * 0.04, height: 1.5),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // -- Sample Work Section --
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: const Text(
                        'Sample Work',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    SizedBox(
                      height: screenHeight * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.01,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              child: Image.network(
                                images[index],
                                width: screenWidth * 0.45,
                                height: screenHeight * 0.28,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 48),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // -- Customization Options Section --
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: const Text(
                        'Customization Options',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    ...options.map((option) {
                      final title = option['title'] ?? '';
                      final imageUrl = option['image'] ?? '';
                      final bulletPoints = List<String>.from(option['bulletPoints'] ?? []);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.012,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(screenWidth * 0.035),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -- Text Section --
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.008),
                                      ...bulletPoints.map(
                                            (point) => Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("• ", style: TextStyle(fontSize: 14)),
                                            Expanded(
                                              child: Text(
                                                point,
                                                style: TextStyle(fontSize: screenWidth * 0.035),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // -- Image Section --
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(screenWidth * 0.035),
                                  bottomRight: Radius.circular(screenWidth * 0.035),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  width: screenWidth * 0.3,
                                  height: screenHeight * 0.12,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
