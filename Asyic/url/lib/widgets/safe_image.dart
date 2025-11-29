import 'package:flutter/material.dart';

class SafeImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SafeImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });



  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? 
          const Icon(Icons.error_outline, color: Colors.red);
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null) {
          return placeholder ?? 
            const Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
