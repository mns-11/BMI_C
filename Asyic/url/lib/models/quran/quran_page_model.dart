import 'package:quran/quran.dart' as quran;
import 'surah_model.dart';
import 'surah_type.dart';
import 'verse_model.dart';

class QuranPageModel {
  final int pageNumber;
  final int juzuNumber;
  final List<SurahModel> surahs;

  QuranPageModel._({
    required this.juzuNumber,
    required this.pageNumber,
    required this.surahs,
  });

  static Future<QuranPageModel> formPageNumber(int pageNumber) async {
    // Simple implementation that creates a basic page model
    // This is a placeholder implementation since we don't have the full page data

    // For now, let's just create a simple model with one surah
    // In a real implementation, you would load the actual page data

    final surahNumber = _getSurahForPage(pageNumber);
    final surahName = quran.getSurahNameArabic(surahNumber);
    final verseCount = quran.getVerseCount(surahNumber);

    // Create a simple verse model
    final verses = <VerseModel>[];
    for (int i = 1; i <= verseCount && i <= 5; i++) {
      // Limit to 5 verses for simplicity
      try {
        final verseText = quran.getVerse(surahNumber, i);
        verses.add(
          VerseModel(
            verseNumber: i,
            text: verseText,
            qcf: '$verseText $i', // Simple placeholder for QCF text
          ),
        );
      } catch (e) {
        // Skip if we can't get the verse
        continue;
      }
    }

    // Create a map that matches the expected JSON structure
    final surahJson = {
      'name': surahName,
      'englishName': quran.getSurahName(surahNumber),
      'englishNameTranslation': '',
    };

    final surah = SurahModel(
      name: SurahNames.fromJson(surahJson),
      number: surahNumber,
      startVerse: 1,
      endVerse: verses.length,
      verses: verses,
      type: SurahType.makia, // Placeholder
    );

    return QuranPageModel._(
      pageNumber: pageNumber,
      surahs: [surah],
      juzuNumber: quran.getJuzNumber(surahNumber, 1),
    );
  }

  // Helper function to determine which surah is on a given page
  static int _getSurahForPage(int pageNumber) {
    // This is a very simplified mapping
    // In a real implementation, you would have a proper mapping of pages to surahs
    if (pageNumber == 1) return 1; // Al-Fatihah
    if (pageNumber < 50) return 2; // Al-Baqarah
    if (pageNumber < 76) return 3; // Aal-Imran
    // ... add more mappings as needed
    return 2; // Default to Al-Baqarah
  }
}
