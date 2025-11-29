class QuranSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<QuranAyah> ayahs;

  const QuranSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: (json['ayahs'] as List)
          .map((ayah) => QuranAyah.fromJson(ayah))
          .toList(),
    );
  }
}

class QuranAyah {
  final int number;
  final String text;
  final String translation;
  final int numberInSurah;

  const QuranAyah({
    required this.number,
    required this.text,
    required this.translation,
    required this.numberInSurah,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      number: json['number'],
      text: json['text'],
      translation: json['translation'],
      numberInSurah: json['numberInSurah'],
    );
  }
}
