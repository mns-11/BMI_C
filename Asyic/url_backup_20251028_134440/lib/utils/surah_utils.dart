import 'package:flutter/material.dart';

/// Returns a widget that displays the Bismillah with proper styling
Widget buildBismillah() {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.6,
              color: Colors.teal,
              fontFamily: 'Amiri',
            ).copyWith(
              fontFamilyFallback: ['NotoSansArabic', 'Arial'],
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          const Text(
            'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// Returns a safe TextStyle for Arabic text with fallback fonts
TextStyle getArabicTextStyle({
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.bold,
  double height = 1.6,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color,
    fontFamily: 'Amiri',
    fontFamilyFallback: ['NotoSansArabic', 'Arial'],
  );
}
