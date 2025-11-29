import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/surah_al_imran_verses.dart' show surahAlImranVerses;
import '../widgets/surah_app_bar.dart';

class SurahAlImranScreen extends StatefulWidget {
  const SurahAlImranScreen({super.key});
  @override
  State<SurahAlImranScreen> createState() => _SurahAlImranScreenState();
}

class _SurahAlImranScreenState extends State<SurahAlImranScreen> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  Future<void> loadVerses() async {
    try {
      // Load verses data
      setState(() {
        verses = surahAlImranVerses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading verses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SurahAppBar(
        title: 'سورة آل عمران',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F8F8), // Light gray from app theme
              Color(0xFFFEFEFE), // Pure white
              Color(0xFFF5F5F5), // Very light gray
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD5580F), // App theme color
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F8F8), // Light gray
                          Color(0xFFFEFEFE), // Pure white
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Verse number
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFD5580F),
                                  Color(0xFFB8860B),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              verse['verseNumber'] == 0 ? 'البسملة' : 'الآية ${verse['verseNumber']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Arabic text
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFFBF7), // Very light cream
                                  Color(0xFFFEFEFE), // Pure white
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFD5580F).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              verse['arabicText'],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                height: 1.8,
                                fontFamily: 'Amiri',
                                color: Color(0xFF1A1A1A), // Darker color for better readability
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Translation
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFEFEFE), // Pure white
                                  Color(0xFFF8F8F8), // Light gray
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0x1AD5580F), // D5580F with 10% opacity
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Translation header
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD5580F),
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'الترجمة:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFD5580F),
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  verse['translation'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.justify,
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Copy current verse to clipboard
          if (verses.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: verses[0]['arabicText']));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم نسخ النص'),
                backgroundColor: Color(0xFFD5580F), // App theme color
              ),
            );
          }
        },
        backgroundColor: const Color(0xFFD5580F),
        elevation: 8, // App theme color
        child: const Icon(Icons.copy, color: Colors.white),
      ),
    );
  }
}



