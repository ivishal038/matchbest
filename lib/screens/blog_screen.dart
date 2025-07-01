import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchbest/provider/api.dart';
import 'dart:convert';
import '../theme/gradient_background.dart';
import 'blog_detail_screen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  late Future<List<Map<String, dynamic>>> blogsFuture;

  @override
  void initState() {
    super.initState();
    blogsFuture = fetchBlogs();
  }

  Future<List<Map<String, dynamic>>> fetchBlogs() async {
    final response = await http.get(Uri.parse('$api/blogs'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.035;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
          title: const Text('Blogs'),
          elevation: 2,
          foregroundColor: Colors.black87,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: blogsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading blogs'));
            } else {
              final blogs = snapshot.data!;
              return GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.03),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth < 600 ? 2 : 3,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                ),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlogDetailScreen(blog: blog)),
                      );
                    },
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                blog['image'],
                                height: screenHeight * 0.17,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: screenWidth * 0.1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    blog['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize * 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.007),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          blog['department'],
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        blog['date'],
                                        style: TextStyle(
                                          fontSize: fontSize * 0.9,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
