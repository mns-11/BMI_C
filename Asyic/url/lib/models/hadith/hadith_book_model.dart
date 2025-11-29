class HadithBook {
  final int id;
  final String name;
  final int hadithCount;
  final List<Hadith>? hadiths;

  const HadithBook({
    required this.id,
    required this.name,
    required this.hadithCount,
    this.hadiths,
  });

  /// Converts this HadithBook to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hadithCount': hadithCount,
      if (hadiths != null)
        'hadiths': hadiths!.map((h) => h.toJson()).toList(),
    };
  }

  /// Creates a HadithBook from a JSON map
  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'غير معروف',
      hadithCount: json['hadithCount'] as int? ?? 0,
      hadiths: json['hadiths'] != null
          ? List<Hadith>.from(
              (json['hadiths'] as List).map((h) => Hadith.fromJson(h)))
          : null,
    );
  }

  /// Creates a copy of this HadithBook with the given fields replaced
  HadithBook copyWith({
    int? id,
    String? name,
    int? hadithCount,
    List<Hadith>? hadiths,
  }) {
    return HadithBook(
      id: id ?? this.id,
      name: name ?? this.name,
      hadithCount: hadithCount ?? this.hadithCount,
      hadiths: hadiths ?? this.hadiths,
    );
  }
}

class Hadith {
  final int id;
  final String arabicText;
  final String englishText;
  final String reference;
  final String? narrator;
  final String? source;
  final String? bookName;
  final int? bookId;
  final String? grade;

  const Hadith({
    required this.id,
    required this.arabicText,
    required this.englishText,
    required this.reference,
    this.narrator,
    this.source,
    this.bookName,
    this.bookId,
    this.grade,
  });

  /// Creates a Hadith from a JSON map
  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as int? ?? 0,
      arabicText: json['arabicText'] as String? ?? '',
      englishText: json['englishText'] as String? ?? json['translation'] ?? '',
      reference: json['reference'] as String? ?? '',
      narrator: json['narrator'] as String?,
      source: json['source'] as String?,
      bookName: json['bookName'] as String?,
      bookId: json['bookId'] as int?,
      grade: json['grade'] as String?,
    );
  }

  /// Creates a copy of this Hadith with the given fields replaced
  Hadith copyWith({
    int? id,
    String? arabicText,
    String? englishText,
    String? reference,
    String? narrator,
    String? source,
    String? bookName,
    int? bookId,
    String? grade,
  }) {
    return Hadith(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      englishText: englishText ?? this.englishText,
      reference: reference ?? this.reference,
      narrator: narrator ?? this.narrator,
      source: source ?? this.source,
      bookName: bookName ?? this.bookName,
      bookId: bookId ?? this.bookId,
      grade: grade ?? this.grade,
    );
  }

  /// Converts this Hadith to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicText': arabicText,
      'englishText': englishText,
      'reference': reference,
      if (narrator != null) 'narrator': narrator,
      if (source != null) 'source': source,
      if (bookName != null) 'bookName': bookName,
      if (bookId != null) 'bookId': bookId,
      if (grade != null) 'grade': grade,
    };
  }

  /// Returns a short preview of the hadith text
  String get preview {
    const maxLength = 100;
    if (arabicText.length <= maxLength) return arabicText;
    return '${arabicText.substring(0, maxLength)}...';
  }

  /// Returns the full reference of the hadith
  String get fullReference {
    final parts = <String>[];
    if (bookName != null) parts.add(bookName!);
    if (reference.isNotEmpty) {
      parts.add(reference);
    } else if (id > 0) {
      parts.add('الحديث رقم: $id');
    }
    return parts.join(' - ');
  }
}
