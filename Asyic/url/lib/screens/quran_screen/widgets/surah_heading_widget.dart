import 'package:flutter/material.dart';
import '../../../models/quran/surah_model.dart';

class SurahHeadingWidget extends StatelessWidget {
  final SurahModel surah;
  final double fontSize;

  const SurahHeadingWidget({
    super.key,
    required this.surah,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        surah.name.arabic,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
