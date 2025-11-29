import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/surah_al_kahf_verses.dart';
import '../widgets/surah_app_bar.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/reciter_selector.dart';
import '../models/reciter.dart';
import '../data/reciters_data.dart';

class SurahAlKahfScreen extends StatefulWidget {
  const SurahAlKahfScreen({super.key});

  @override
  State<SurahAlKahfScreen> createState() => _SurahAlKahfScreenState();
}

class _SurahAlKahfScreenState extends State<SurahAlKahfScreen> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;
  late Reciter selectedReciter;

  @override
  void initState() {
    super.initState();
    selectedReciter = reciters.first;
    loadVerses();
  }

  Future<void> loadVerses() async {
    try {
      setState(() {
        verses = surahAlKahfVerses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading verses: $e')),
        );
      }
    }
  }

  void _onReciterChanged(Reciter reciter) {
    setState(() {
      selectedReciter = reciter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SurahAppBar(
        title: 'سورة الكهف',
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFB8860B),
                ),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                children: [
                  // Audio Section
                  ReciterSelector(
                    selectedReciter: selectedReciter,
                    onReciterChanged: _onReciterChanged,
                  ),

                  AudioPlayerWidget(
                    audioUrl: selectedReciter.surahs.firstWhere((surah) => surah.title == 'الكهف').audioUrl,
                    surahName: 'سورة الكهف',
                    reciterName: selectedReciter.name,
                  ),

                  const SizedBox(height: 16),

                  // Verses Section Title
                  // Verses List
                  ...verses.map((verse) => Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F8F8),
                          Color(0xFFFEFEFE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD5580F).withValues(alpha: 0.2),
                        width: 1,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Verses number with golden styling
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFD5580F),
                                      Color(0xFFB8860B),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    verse['verseNumber'] == 0 ? '﷽' : '${verse['verseNumber']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Enhanced Arabic text with better typography
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFFBF7),
                                  Color(0xFFFEFEFE),
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
                                color: Color(0xFF1A1A1A),
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Enhanced translation with better styling
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFEFEFE),
                                  Color(0xFFF8F8F8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0x1AD5580F),
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
                                const SizedBox(height: 12),
                                Text(
                                  verse['translation'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
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
                  )),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (verses.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: verses[0]['arabicText']));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم نسخ النص'),
                backgroundColor: Color(0xFFD5580F),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFFD5580F),
        elevation: 8,
        child: const Icon(Icons.copy, color: Colors.white),
      ),
    );
  }
}
