import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImageUtils {
  static final List<String> imagePaths = [
    'assets/images/bee43d6de93dbd60fc7c0943ec071779.png.webp',
    'assets/images/839fa1a43d6988809d0796f619eba1c8.jpg',
  ];

  static Future<void> precacheAppImages(BuildContext context) async {
    try {
      // Precaching app images
      for (final path in imagePaths) {
        try {
          // Load the image to ensure it exists
          await rootBundle.load(path);
          
          // Precache the image with the provided context
          await precacheImage(
            AssetImage(path),
            context,
          );
          
          debugPrint('Successfully precached image: $path');
        } catch (e) {
          debugPrint('Failed to precache image: $path, error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error in precaching images: $e');
    }
  }
  
  // Helper method to get the image provider
  static ImageProvider getImageProvider(String path) {
    return AssetImage(path);
  }
}
