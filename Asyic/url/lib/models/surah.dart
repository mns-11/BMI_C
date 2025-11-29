class Surah {
  final int id;
  final String nameArabic;
  final String nameSimple;
  final String nameEnglish;
  final String revelationPlace;
  final int versesCount;
  final int? pagesStart;
  final int? pagesEnd;

  Surah({
    required this.id,
    required this.nameArabic,
    required this.nameSimple,
    required this.nameEnglish,
    required this.revelationPlace,
    required this.versesCount,
    this.pagesStart,
    this.pagesEnd,
  });

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      id: map['id'],
      nameArabic: map['name_arabic'] ?? '',
      nameSimple: map['name_simple'] ?? '',
      nameEnglish: map['name_english'] ?? '',
      revelationPlace: map['revelation_place'] ?? 'makkah',
      versesCount: map['verses_count'] ?? 0,
      pagesStart: map['pages_start'],
      pagesEnd: map['pages_end'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_arabic': nameArabic,
      'name_simple': nameSimple,
      'name_english': nameEnglish,
      'revelation_place': revelationPlace,
      'verses_count': versesCount,
      'pages_start': pagesStart,
      'pages_end': pagesEnd,
    };
  }
}
