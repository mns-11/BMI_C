import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_model.dart';

class QuranService {
  static Future<List<QuranSurah>> loadQuran() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quran.json');
      final data = json.decode(response);
      
      List<dynamic> surahsJson = data['surahs'];
      return surahsJson.map((surah) => QuranSurah.fromJson(surah)).toList();
    } catch (e) {
      print('Error loading Quran data: $e');
      return [];
    }
  }

  static Future<QuranSurah?> getSurah(int surahNumber) async {
    final surahs = await loadQuran();
    try {
      return surahs.firstWhere((surah) => surah.number == surahNumber);
    } catch (e) {
      print('Surah not found: $surahNumber');
      return null;
    }
  }
}
