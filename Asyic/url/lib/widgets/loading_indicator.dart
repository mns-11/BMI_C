import 'package:flutter/material.dart';

/// A reusable loading indicator widget with a circular progress indicator and optional text
class LoadingIndicator extends StatelessWidget {
  /// The message to display below the loading indicator
  final String? message;

  /// The color of the loading indicator
  final Color? color;

  /// The size of the loading indicator
  final double size;

  /// The size of the loading indicator stroke width
  final double strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 40.0,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
              strokeWidth: strokeWidth,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
