import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/quran/quran_surah_model.dart';

class QuranApiService {
  // Using Tanzil API for more reliable Quran text
  static const String _baseUrl = 'https://api.tanzil.net/v1';

  // Fallback to local assets if API fails
  Future<List<Map<String, dynamic>>> getAllSurahs() async {
    try {
      // First try the API
      final response = await http
          .get(
            Uri.parse('$_baseUrl/surahs'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }

      // If API fails, use local data
      return _getLocalSurahs();
    } catch (e) {
      // Fallback to local data on any error
      return _getLocalSurahs();
    }
  }

  Future<List<Map<String, dynamic>>> _getLocalSurahs() async {
    final String response = await rootBundle.loadString(
      'assets/data/quran/surahs.json',
    );
    final data = await json.decode(response);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<QuranSurahModel> getSurah(int surahNumber) async {
    try {
      // Get surah info
      final surahs = await getAllSurahs();
      final surahInfo = surahs.firstWhere(
        (s) => s['number'] == surahNumber,
        orElse: () => throw Exception('Surah not found'),
      );

      // Get verses from API
      final response = await http
          .get(
            Uri.parse('$_baseUrl/surahs/$surahNumber/verses?words=true'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final verses = List<Map<String, dynamic>>.from(data['data']);

        // Create a list of QuranAyah objects from the API data
        final List<QuranAyah> ayahList = verses
            .map(
              (v) => QuranAyah(
                number: v['number'],
                text: v['text'],
                translation: '', // Will be added later
                numberInSurah: v['numberInSurah'],
                audioUrl: '', // Will be added later
              ),
            )
            .toList();

        return QuranSurahModel(
          number: surahNumber,
          name: surahInfo['name'],
          englishName: surahInfo['englishName'],
          englishNameTranslation: surahInfo['englishNameTranslation'] ?? '',
          revelationType: surahInfo['revelationType'] ?? 'Meccan',
          numberOfAyahs: surahInfo['numberOfAyahs'],
          verses: ayahList,
          pageStart: 0, // Default value until we have actual data
          pageEnd: 0, // Default value until we have actual data
        );
      } else {
        // Fallback to local data if API fails
        return _getLocalSurah(surahNumber);
      }
    } catch (e) {
      // Fallback to local data on any error
      return _getLocalSurah(surahNumber);
    }
  }

  Future<QuranSurahModel> _getLocalSurah(int surahNumber) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/quran/surah_$surahNumber.json',
      );
      final data = await json.decode(response);
      return QuranSurahModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load surah $surahNumber: $e');
    }
  }
}
