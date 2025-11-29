import 'package:quran/quran.dart' as quran;
import 'package:flutter/foundation.dart';
import '../models/quran/quran_surah_model.dart';

/// A service class that provides access to Quran data.
class QuranService {
  static List<QuranSurahModel>? _cachedSurahs;

  /// Loads all Quran surahs using the quran package
  static Future<List<QuranSurahModel>> loadArabicQuran() async {
    if (_cachedSurahs != null) return _cachedSurahs!;

    try {
      _cachedSurahs = [];

      // Load all 114 surahs
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        try {
          final surah = QuranSurahModel(
            number: surahNumber,
            name: quran.getSurahNameArabic(surahNumber),
            englishName: quran.getSurahName(surahNumber),
            englishNameTranslation: quran.getSurahName(surahNumber),
            revelationType: quran.getPlaceOfRevelation(surahNumber) == 'Meccan'
                ? 'مكية'
                : 'مدنية',
            numberOfAyahs: quran.getVerseCount(surahNumber),
            verses: [], // Changed from ayahs to verses
            pageStart: 0, // Default value until we have actual data
            pageEnd: 0, // Default value until we have actual data
          );
          _cachedSurahs!.add(surah);
        } catch (e) {
          debugPrint('Error loading surah $surahNumber: $e');
          // Continue with next surah even if one fails
          continue;
        }
      }

      if (_cachedSurahs!.isEmpty) {
        throw Exception('Failed to load any surahs');
      }

      return _cachedSurahs!;
    } catch (e) {
      debugPrint('Error in loadArabicQuran: $e');
      rethrow;
    }
  }

  /// Get a specific surah by its number
  static Future<QuranSurahModel?> getSurahById(int surahNumber) async {
    try {
      final surahs = await loadArabicQuran();
      return surahs.firstWhere(
        (surah) => surah.number == surahNumber,
        orElse: () => throw Exception('Surah $surahNumber not found'),
      );
    } catch (e) {
      debugPrint('Error getting surah $surahNumber: $e');
      return null;
    }
  }

  /// Search for ayahs containing the query text
  static Future<List<Map<String, dynamic>>> searchAyahs(String query) async {
    final results = <Map<String, dynamic>>[];
    try {
      final surahs = await loadArabicQuran();

      for (final surah in surahs) {
        for (
          int ayahNumber = 1;
          ayahNumber <= surah.numberOfAyahs;
          ayahNumber++
        ) {
          try {
            final ayahText = quran.getVerse(surah.number, ayahNumber);
            // For Arabic text search, we should search without case conversion
            if (ayahText.contains(query) ||
                ayahText.contains(query.toLowerCase()) ||
                ayahText.contains(query.toUpperCase())) {
              results.add({
                'surahNumber': surah.number,
                'surahName': surah.name,
                'ayahNumber': ayahNumber,
                'text': ayahText,
              });
            }
          } catch (e) {
            debugPrint(
              'Error processing surah ${surah.number} ayah $ayahNumber: $e',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error in searchAyahs: $e');
      rethrow;
    }

    return results;
  }
}
//   static Future<QuranSurahModel?> getSurah(int surahNumber) async {
//     try {
//       final surahs = await loadArabicQuran();
//       return surahs.firstWhere((s) => s.number == surahNumber);
//     } catch (e) {
//       debugPrint('Error getting surah $surahNumber: $e');
//       return null;
//     }
//   }
//   static List<QuranSurahModel>? _cachedSurahs;
//
//   /// Loads all Quran surahs using the quran package
//   static Future<List<QuranSurahModel>> loadArabicQuran() async {
//     if (_cachedSurahs != null) {
//       return _cachedSurahs!;
//     }
//
//     try {
//       _cachedSurahs = [];
//      
//       // Get total number of surahs (114)
//       for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
//         try {
//           final surahName = quran.getSurahNameArabic(surahNumber);
//           final englishName = quran.getSurahName(surahNumber);
//           final revelationType = quran.getPlaceOfRevelation(surahNumber) == 'Meccan' ? 'مكية' : 'مدنية';
//           final numberOfAyahs = quran.getVerseCount(surahNumber);
//          
//           // Get all verses for this surah
//           final List<QuranAyah> ayahs = [];
//           for (int ayahNumber = 1; ayahNumber <= numberOfAyahs; ayahNumber++) {
//             final ayahText = quran.getVerse(surahNumber, ayahNumber, verseEndSymbol: false);
//             ayahs.add(QuranAyah(
//               number: ayahNumber,
//               text: ayahText,
//               surahNumber: surahNumber,
//             ));
//           }
//          
//           final surah = QuranSurahModel(
//             number: surahNumber,
//             name: surahName,
//             englishName: englishName,
//             englishNameTranslation: englishName, // Using englishName as translation for simplicity
//             revelationType: revelationType,
//             numberOfAyahs: numberOfAyahs,
//             ayahs: ayahs,
//           );
//          
//           _cachedSurahs!.add(surah);
//             'revelationType': surahJson['type'] ?? 'meccan',
//             'numberOfAyahs': surahJson['total_verses'] ?? 0,
//             'ayahs': ((surahJson['verses'] as List?) ?? []).map<Map<String, dynamic>>((verse) => {
//               'number': verse['id'] ?? 0,
//               'translation': '',
//               'numberInSurah': verse['id'] ?? 0,
//             }).toList(),
//           };
//          
//         } catch (e) {
//           debugPrint('Error loading surah $surahNumber: $e');
//           // Continue with next surah
//         }
//       }
//      
//       return _cachedSurahs!;
//     } catch (e, stackTrace) {
//       debugPrint('Error loading Quran: $e\n$stackTrace');
//       rethrow;
//     }
//   }
//
//   /// Get a specific surah by its number
//   static Future<QuranSurahModel?> getSurah(int surahNumber) async {
//     final surahs = await loadArabicQuran();
//     try {
//       return surahs.firstWhere((surah) => surah.number == surahNumber);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get a specific verse by surah and verses number
//   static Future<QuranAyah?> getVerse(int surahNumber, int versesNumber) async {
//     try {
//       final surahs = await loadArabicQuran();
//       final results = <QuranAyah>[];
//      
//       for (final surah in surahs) {
//         for (final ayah in surah.ayahs) {
//           if (ayah.text.contains(query) || 
//               ayah.translation.toLowerCase().contains(query.toLowerCase())) {
//             results.add(ayah);
//           }
//         }
//       }
//      
//       return results;
//     } catch (e) {
//       log('Error searching ayahs: $e');
//       return [];
//     }
//   }
// }