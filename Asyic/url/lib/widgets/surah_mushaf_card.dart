import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Elegant Mushaf-style Surah Card
/// - Uses green/gold Islamic background
/// - Ornate geometric border
/// - Madinah Mushaf font (from assets)
/// - Preserves Quranic symbols and stop marks
class SurahMushafCard extends StatelessWidget {
  final String surahText;
  final String surahName;
  final int surahNumber;

  const SurahMushafCard({
    Key? key,
    required this.surahText,
    required this.surahName,
    required this.surahNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF176A3A), Color(0xFFBFA14A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFFBFA14A),
            width: 6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/mushaf_bg.png'), // Add a subtle Islamic pattern here
            fit: BoxFit.cover,
            opacity: 0.18,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'سورة $surahName',
                style: const TextStyle(
                  fontFamily: 'QCF2BSMLfonts', // Mushaf font from assets/fonts
                  fontSize: 32,
                  color: Color(0xFF176A3A),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFFBFA14A),
                      blurRadius: 8,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFBFA14A),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  surahText,
                  style: const TextStyle(
                    fontFamily: 'QCF2BSMLfonts', // Mushaf font
                    fontSize: 28,
                    color: Color(0xFF176A3A),
                    height: 2.1,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
