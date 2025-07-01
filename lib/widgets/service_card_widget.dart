import 'package:flutter/material.dart';

class ServiceCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ServiceCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.onTap,
  });

  String _getShortDescription(String text, {int wordLimit = 5}) {
    final words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return '${words.take(wordLimit).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSizeTitle = screenWidth * 0.04; // Responsive title size
    final fontSizeDesc = screenWidth * 0.035; // Responsive desc size

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Image Section --
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: screenWidth * 0.28, // responsive height
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: screenWidth * 0.28,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            // -- Text Section --
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getShortDescription(description),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSizeDesc,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
