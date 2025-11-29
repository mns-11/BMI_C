class Ayah {
  final int id;
  final int surahId;
  final int verseNumber;
  final String textUthmani;
  final String? translation;
  final int? juz;
  final int? page;
  final int? hizbQuarter;
  final bool? sajda;

  Ayah({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.textUthmani,
    this.translation,
    this.juz,
    this.page,
    this.hizbQuarter,
    this.sajda,
  });

  factory Ayah.fromMap(Map<String, dynamic> map) {
    return Ayah(
      id: map['id'],
      surahId: map['surah_id'],
      verseNumber: map['verse_number'],
      textUthmani: map['text_uthmani'] ?? '',
      translation: map['translation'],
      juz: map['juz'],
      page: map['page'],
      hizbQuarter: map['hizb_quarter'],
      sajda: map['sajda'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surah_id': surahId,
      'verse_number': verseNumber,
      'text_uthmani': textUthmani,
      'translation': translation,
      'juz': juz,
      'page': page,
      'hizb_quarter': hizbQuarter,
      'sajda': sajda == true ? 1 : 0,
    };
  }
}
