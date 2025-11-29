import 'package:flutter/foundation.dart';
import 'package:quran/quran.dart' as quran;
import '../services/quran_service.dart';
// ../models/quran/quran_surah_model.dart is not needed in this util file

/// A utility class for handling Quran-related operations
class QuranUtils {
  /// (previously had default constants for juz/page; not needed because the
  /// underlying library returns non-nullable ints)

  /// Validates surah ID is within valid range (1-114)
  static bool _isValidSurahId(int surahId) {
    return surahId >= 1 && surahId <= 114;
  }

  /// Validates verse ID is a positive number
  static bool _isValidVerseId(int verseId) {
    return verseId > 0;
  }

  /// Gets all verses from a specific surah
  static Future<List<Map<String, dynamic>>> getVersesBySurah(
    int surahId,
  ) async {
    if (!_isValidSurahId(surahId)) {
      debugPrint('Invalid surah ID: $surahId');
      return [];
    }

    try {
      final surah = await QuranService.getSurahById(surahId);
      if (surah == null) return [];

      final List<Map<String, dynamic>> verses = [];

      for (int i = 1; i <= surah.numberOfAyahs; i++) {
        try {
          final verseText = quran.getVerse(surahId, i, verseEndSymbol: true);
          if (verseText.isNotEmpty) {
            verses.add({
              'surahNumber': surahId,
              'surahName': surah.name,
              'ayahNumber': i,
              'text': verseText,
              'juz': quran.getJuzNumber(surahId, i),
              'page': quran.getPageNumber(surahId, i),
            });
          }
        } catch (e) {
          debugPrint('Error getting verse $i from surah $surahId: $e');
        }
      }

      return verses;
    } catch (e) {
      debugPrint('Error getting verses for surah $surahId: $e');
      return [];
    }
  }

  /// Searches for verses containing the query text
  static Future<List<Map<String, dynamic>>> searchInQuran(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final results = await QuranService.searchAyahs(query);
      final List<Map<String, dynamic>> enhancedResults = [];

      for (final ayah in results) {
        try {
          final surahNumber = ayah['surahNumber'] as int;
          final ayahNumber = ayah['ayahNumber'] as int;

          enhancedResults.add({
            ...ayah,
            'juz': quran.getJuzNumber(surahNumber, ayahNumber),
            'page': quran.getPageNumber(surahNumber, ayahNumber),
          });
        } catch (e) {
          debugPrint('Error enhancing search result: $e');
        }
      }

      return enhancedResults;
    } catch (e) {
      debugPrint('Error searching in Quran: $e');
      return [];
    }
  }

  /// Gets a specific verse by surah and verse number
  static Future<Map<String, dynamic>?> getVerse(
    int surahId,
    int verseId,
  ) async {
    if (!_isValidSurahId(surahId) || !_isValidVerseId(verseId)) {
      return null;
    }

    try {
      final verseText = quran.getVerse(surahId, verseId, verseEndSymbol: true);
      if (verseText.isEmpty) return null;

      final juz = quran.getJuzNumber(surahId, verseId);
      final page = quran.getPageNumber(surahId, verseId);

      return {
        'surahNumber': surahId,
        'surahName': quran.getSurahNameArabic(surahId),
        'ayahNumber': verseId,
        'text': verseText,
        'juz': juz,
        'page': page,
      };
    } catch (e) {
      debugPrint('Error getting verse $verseId from surah $surahId: $e');
      return null;
    }
  }
}
