class QuranAyah {
  final int number;
  final String text;
  final String translation;
  final int numberInSurah;
  final String audioUrl;

  QuranAyah({
    required this.number,
    required this.text,
    required this.translation,
    required this.numberInSurah,
    required this.audioUrl,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      number: json['number'] as int,
      text: json['text'] as String,
      translation: json['translation'] as String,
      numberInSurah: json['numberInSurah'] as int,
      audioUrl: json['audioUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'translation': translation,
      'numberInSurah': numberInSurah,
      'audioUrl': audioUrl,
    };
  }
}

class QuranSurahModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<QuranAyah> verses; // Changed from ayahs to verses
  final int pageStart;
  final int pageEnd;

  QuranSurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.verses, // Changed from ayahs to verses
    required this.pageStart,
    required this.pageEnd,
  });

  factory QuranSurahModel.fromJson(Map<String, dynamic> json) {
    return QuranSurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      verses:
          (json['verses'] as List) // Changed from ayahs to verses
              .map((ayah) => QuranAyah.fromJson(ayah as Map<String, dynamic>))
              .toList(),
      pageStart: json['pageStart'] as int,
      pageEnd: json['pageEnd'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'verses': verses
          .map((ayah) => ayah.toJson())
          .toList(), // Changed from ayahs to verses
      'pageStart': pageStart,
      'pageEnd': pageEnd,
    };
  }
}

// Backwards-compatible alias: some parts of the app expect `ayahs`.
extension QuranSurahModelCompatibility on QuranSurahModel {
  List<QuranAyah> get ayahs => verses;
}
