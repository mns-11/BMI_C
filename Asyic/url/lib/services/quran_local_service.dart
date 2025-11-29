import '../models/quran/quran_surah_model.dart';

class QuranLocalService {
  // Commented out since the files don't exist
  // static const String _quranArabicPath = 'assets/data/quran/arabic.json';

  /// Load all surahs from the local Arabic JSON file
  static Future<List<QuranSurahModel>> loadSurahsFromLocal() async {
    // Return empty list since we're not using local files
    return [];
    /*try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(_quranArabicPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      // Convert JSON data to QuranSurahModel objects
      return jsonData.map((surah) {
        return QuranSurahModel.fromJson({
          'number': surah['id'] as int,
          'name': surah['name'] as String,
          'englishName': surah['transliteration'] as String,
          'englishNameTranslation': '', // Not available in current JSON
          'revelationType': surah['type'] as String,
          'numberOfAyahs': surah['total_verses'] as int,
          'ayahs': (surah['verses'] as List)
              .map(
                (verse) => {
                  'number': verse['id'] as int,
                  'text': verse['text'] as String,
                  'translation': '',
                  'numberInSurah': verse['id'] as int,
                  'audioUrl': '',
                },
              )
              .toList(),
          'pageStart': 0, // Default value until we have actual data
          'pageEnd': 0, // Default value until we have actual data
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to load local Quran data: $e');
    }*/
  }

  /// Load a specific surah with its ayahs from the local Arabic JSON file
  static Future<QuranSurahModel> loadSurahWithAyahsFromLocal(
    int surahNumber,
  ) async {
    // Throw exception to force API loading since we're not using local files
    throw Exception('Local files not available, using API instead');
    /*try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(_quranArabicPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      // Find the specific surah
      final surahData = jsonData.firstWhere(
        (surah) => surah['id'] == surahNumber,
        orElse: () =>
            throw Exception('Surah with number $surahNumber not found'),
      );

      // Convert to QuranSurahModel
      return QuranSurahModel.fromJson({
        'number': surahData['id'] as int,
        'name': surahData['name'] as String,
        'englishName': surahData['transliteration'] as String,
        'englishNameTranslation': '', // Not available in current JSON
        'revelationType': surahData['type'] as String,
        'numberOfAyahs': surahData['total_verses'] as int,
        'ayahs': (surahData['verses'] as List)
            .map(
              (verse) => {
                'number': verse['id'] as int,
                'text': verse['text'] as String,
                'translation': '',
                'numberInSurah': verse['id'] as int,
                'audioUrl': '',
              },
            )
            .toList(),
        'pageStart': 0, // Default value until we have actual data
        'pageEnd': 0, // Default value until we have actual data
      });
    } catch (e) {
      throw Exception('Failed to load surah $surahNumber from local data: $e');
    }*/
  }
}
