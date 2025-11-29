class MuslimHadith {
  final int id;
  final String bookName;
  final int bookNumber;
  final String arabicText;
  final String englishText;
  final String reference;

  MuslimHadith({
    required this.id,
    required this.bookName,
    required this.bookNumber,
    required this.arabicText,
    required this.englishText,
    required this.reference,
  });

  factory MuslimHadith.fromJson(Map<String, dynamic> json) {
    return MuslimHadith(
      id: json['id'] as int,
      bookName: json['bookName'] as String,
      bookNumber: json['bookNumber'] as int,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String,
      reference: json['reference'] as String,
    );
  }
}
