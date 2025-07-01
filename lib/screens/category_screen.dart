import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchbest/provider/api.dart';
import 'dart:convert';
import '../theme/gradient_background.dart';
import '../widgets/service_card_widget.dart';
import 'form_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String serviceId;
  final String serviceTitle;
  final String serviceImageUrl;

  const CategoryScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceImageUrl,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Map<String, String>>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories(widget.serviceId);
  }

  Future<List<Map<String, String>>> fetchCategories(String serviceId) async {
    final response = await http.get(Uri.parse('$api/categories/$serviceId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Map<String, String>>((category) => {
        '_id': category['_id'].toString(),
        'title': category['title'] ?? '',
        'description': category['description'] ?? '',
        'imageUrl': category['imageUrl'] ?? '',
      }).toList();
    } else {
      throw Exception('Failed to load categories');
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
          title: Text(widget.serviceTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 1,
          foregroundColor: Colors.black87,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --- Top Banner ---
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.serviceImageUrl,
                    width: double.infinity,
                    height: screenHeight * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
              ),

              // --- Section Title ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category, color: Colors.purple),
                    SizedBox(width: screenWidth * 0.02),
                    const Text(
                      'Select a Category',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // --- Grid of Categories ---
              FutureBuilder<List<Map<String, String>>>(
                future: categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading categories'));
                  } else {
                    final categories = snapshot.data!;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: screenHeight * 0.02,
                          crossAxisSpacing: screenWidth * 0.03,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(12),
                            child: ServiceCardWidget(
                              title: category['title']!,
                              description: category['description']!,
                              imageUrl: category['imageUrl']!,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormScreen(
                                      categoryId: category['_id']!,
                                      categoryTitle: category['title']!,
                                      serviceTitle: widget.serviceTitle,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
