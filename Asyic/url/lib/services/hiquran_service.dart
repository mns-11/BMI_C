import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/quran/quran_surah_model.dart';

class HiQuranService {
  // Using AlQuran Cloud API - stable and reliable
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  static Future<List<QuranSurahModel>> fetchSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahsData = data['data'] ?? [];

        return surahsData.map((surah) {
          return QuranSurahModel.fromJson({
            'number': surah['number'],
            'name': surah['name'],
            'englishName': surah['englishName'],
            'englishNameTranslation': surah['englishNameTranslation'],
            'revelationType': surah['revelationType'].toLowerCase(),
            'numberOfAyahs': surah['numberOfAyahs'],
            'verses': [], // Will be loaded separately
            'pageStart': 0, // Default value until we have actual data
            'pageEnd': 0, // Default value until we have actual data
          });
        }).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching surahs: $e');
      rethrow;
    }
  }

  static Future<QuranSurahModel> fetchSurahWithAyahs(int surahNumber) async {
    try {
      // Fetch both text and audio in parallel
      final textResponse = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/quran-uthmani'),
        headers: {'Accept': 'application/json'},
      );

      final audioResponse = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/ar.abdulbasitmurattal'),
        headers: {'Accept': 'application/json'},
      );

      if (textResponse.statusCode == 200 && audioResponse.statusCode == 200) {
        final Map<String, dynamic> textData = json.decode(textResponse.body);
        final Map<String, dynamic> audioData = json.decode(audioResponse.body);

        final textSurahData = textData['data'];
        final audioSurahData = audioData['data'];

        // Combine text and audio data
        final List textAyahs = textSurahData['ayahs'] as List;
        final List audioAyahs = audioSurahData['ayahs'] as List;

        // Create a map of audio URLs by ayah number for easy lookup
        final Map<int, String> audioUrls = {};
        for (var audioAyah in audioAyahs) {
          audioUrls[audioAyah['numberInSurah']] = audioAyah['audio'];
        }

        return QuranSurahModel.fromJson({
          'number': textSurahData['number'],
          'name': textSurahData['name'],
          'englishName': textSurahData['englishName'],
          'englishNameTranslation': textSurahData['englishNameTranslation'],
          'revelationType': textSurahData['revelationType'].toLowerCase(),
          'numberOfAyahs': textSurahData['numberOfAyahs'],
          'verses': textAyahs
              .map(
                (ayah) => {
                  'number': ayah['numberInSurah'],
                  'text': ayah['text'],
                  'translation': '',
                  'numberInSurah': ayah['numberInSurah'],
                  'audioUrl': audioUrls[ayah['numberInSurah']] ?? '',
                },
              )
              .toList(),
          'pageStart': 0, // Default value until we have actual data
          'pageEnd': 0, // Default value until we have actual data
        });
      } else {
        throw Exception(
          'Failed to load surah $surahNumber: text=${textResponse.statusCode}, audio=${audioResponse.statusCode}',
        );
      }
    } catch (e) {
      log('Error fetching surah $surahNumber: $e');
      rethrow;
    }
  }
}
