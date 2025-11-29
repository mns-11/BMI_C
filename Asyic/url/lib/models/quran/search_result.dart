import 'package:quran/quran.dart';

class SearchResult {
  final int surahNumber;
  final int verseNumber;

  int get pageNumber => getPageNumber(surahNumber, verseNumber);
  // {occurences : int, result : [{surah_number:int, verse_number:int}]}

  SearchResult({required this.surahNumber, required this.verseNumber});

  factory SearchResult.fromJson(Map result) {
    return SearchResult(
      surahNumber: result['surah_number'],
      verseNumber: result['verse_number'],
    );
  }

  factory SearchResult.surahNumber(int result) {
    return SearchResult(surahNumber: result, verseNumber: 1);
  }
}
