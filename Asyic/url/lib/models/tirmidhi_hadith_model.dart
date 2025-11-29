class TirmidhiHadith {
  final int id;
  final String bookName;
  final int bookNumber;
  final String arabicText;
  final String englishText;
  final String reference;

  TirmidhiHadith({
    required this.id,
    required this.bookName,
    required this.bookNumber,
    required this.arabicText,
    required this.englishText,
    required this.reference,
  });

  factory TirmidhiHadith.fromJson(Map<String, dynamic> json) {
    return TirmidhiHadith(
      id: json['id'] as int,
      bookName: json['bookName'] as String,
      bookNumber: json['bookNumber'] as int,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String,
      reference: json['reference'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': bookName,
      'bookNumber': bookNumber,
      'arabicText': arabicText,
      'englishText': englishText,
      'reference': reference,
    };
  }
}