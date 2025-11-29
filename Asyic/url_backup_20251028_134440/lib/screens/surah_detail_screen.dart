import 'package:flutter/material.dart';
import '../models/quran_model.dart';
import '../theme/app_theme.dart';

class SurahDetailScreen extends StatelessWidget {
  final QuranSurah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.appBarGradient,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F8F8),
              Color(0xFFFEFEFE),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: surah.ayahs.length,
          itemBuilder: (context, index) {
            final ayah = surah.ayahs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Arabic Text
                    Text(
                      ayah.text,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Amiri', // Arabic font
                        height: 1.8,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12.0),
                    
                    // Translation
                    Text(
                      ayah.translation,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    
                    // Ayah number
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Ayah ${ayah.numberInSurah}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
