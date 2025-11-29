import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/quran_service.dart';
import '../models/quran_model.dart';
import 'surah_detail_screen.dart';

class QuranSurahsScreen extends StatefulWidget {
  const QuranSurahsScreen({super.key});

  @override
  State<QuranSurahsScreen> createState() => _QuranSurahsScreenState();
}

class _QuranSurahsScreenState extends State<QuranSurahsScreen> {
  late Future<List<QuranSurah>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = QuranService.loadQuran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سور القرآن الكريم'),
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
        child: FutureBuilder<List<QuranSurah>>(
          future: _surahsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('حدث خطأ أثناء تحميل السور: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد سور متاحة'));
            }

            final surahs = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailScreen(surah: surah),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${surah.number}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Amiri',
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${surah.englishName} • ${surah.numberOfAyahs} آيات',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            surah.englishNameTranslation,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
