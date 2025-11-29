import 'package:flutter/material.dart';

class HeaderCornerWidget extends StatelessWidget {
  final String text;
  final double width;

  const HeaderCornerWidget({super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}