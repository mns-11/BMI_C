import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/muslim_hadith_model.dart';

class MuslimService {
  static const String _dataPath = 'assets/data/hadiths/muslim_data.json';

  /// Loads all Sahih Muslim hadiths by book
  static Future<Map<String, List<MuslimHadith>>> getHadithsByBook() async {
    try {
      // Load data from the complete Muslim JSON file
      final String jsonString = await rootBundle.loadString(_dataPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      final Map<String, List<MuslimHadith>> hadithsByBook = {};

      for (var item in jsonData) {
        final bookName = item['bookName'] as String;
        final hadith = MuslimHadith(
          id: item['id'],
          bookName: bookName,
          bookNumber: item['bookNumber'],
          arabicText: item['arabicText'] ?? '',
          englishText: item['englishText'] ?? '',
          reference: item['reference'] ?? 'صحيح مسلم',
        );

        if (!hadithsByBook.containsKey(bookName)) {
          hadithsByBook[bookName] = [];
        }
        hadithsByBook[bookName]!.add(hadith);
      }

      return hadithsByBook;
    } catch (e) {
      print('Error in MuslimService: $e');
      rethrow;
    }
  }

  /// Searches hadiths by query
  static Future<List<MuslimHadith>> searchHadiths(String query) async {
    try {
      final hadithsByBook = await getHadithsByBook();
      final allHadiths = hadithsByBook.values.expand((h) => h).toList();

      if (query.isEmpty) return allHadiths;

      final lowercaseQuery = query.toLowerCase();
      return allHadiths.where((hadith) {
        return hadith.arabicText.toLowerCase().contains(lowercaseQuery) ||
            hadith.englishText.toLowerCase().contains(lowercaseQuery) ||
            hadith.reference.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Error searching hadiths: $e');
      return [];
    }
  }
}
