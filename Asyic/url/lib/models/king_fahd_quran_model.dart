class KingFahdSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<Map<String, dynamic>>? ayahs;

  KingFahdSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    this.ayahs,
  });

  factory KingFahdSurah.fromJson(Map<String, dynamic> json) {
    return KingFahdSurah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: json['ayahs'] != null 
          ? List<Map<String, dynamic>>.from(json['ayahs'])
          : null,
    );
  }
}

class KingFahdAyah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;
  final int surahNumber;

  KingFahdAyah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    required this.surahNumber,
  });

  factory KingFahdAyah.fromJson(Map<String, dynamic> json) {
    return KingFahdAyah(
      number: json['number'],
      text: json['text'],
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'] ?? false,
      surahNumber: json['surah'] is Map 
          ? json['surah']['number'] 
          : json['surahNumber'] ?? 0,
    );
  }
}
