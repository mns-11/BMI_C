// import 'package:qurani_app/models/surah_type.dart';
// import 'package:qurani_app/models/verse_model.dart';
import 'surah_type.dart';
import 'verse_model.dart';

class SurahModel {
  final int startVerse;
  final int endVerse;
  int get numberOfVerses => endVerse;
  final SurahNames name;
  final int number;
  final SurahType type;
  final List<VerseModel> verses;

  SurahModel({
    required this.number,
    required this.startVerse,
    required this.endVerse,
    required this.name,
    required this.verses,
    required this.type,
  });

  String get versesAsString {
    return verses.fold('', (previousValue, element) {
      if (verses.first == element) {
        var firstAya = element.qcfNoVerseNumber;
        firstAya.replaceFirst(element.qcfNoVerseNumber[0], '');
        previousValue += '$firstAya${element.verseNumberAsQcf}';
        return previousValue
            .replaceAll(' ', '')
            .replaceFirst(previousValue[0], '${firstAya[0]}\u200a');
      }
      previousValue += '${element.qcfNoVerseNumber}${element.verseNumberAsQcf}';
      return previousValue.replaceAll(' ', '');
    });
  }
}

class SurahNames {
  String arabic;
  String arabicTranslated;
  String english;

  SurahNames._(this.arabic, this.english, this.arabicTranslated);

  factory SurahNames.fromJson(Map<String, dynamic> json) {
    return SurahNames._(
      json['name'],
      json['englishName'],
      json['englishNameTranslation'],
    );
  }
}
