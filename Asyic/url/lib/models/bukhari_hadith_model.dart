class BukhariHadith {
  final int id;
  final int bookId;
  final String bookName;
  final String arabic;
  final String? english;
  final String reference;

  BukhariHadith({
    required this.id,
    required this.bookId,
    required this.bookName,
    required this.arabic,
    this.english,
    required this.reference,
  });

  factory BukhariHadith.fromJson(Map<String, dynamic> json) {
    return BukhariHadith(
      id: json['id'],
      bookId: json['bookId'],
      bookName: json['bookName'],
      arabic: json['arabic'],
      english: json['english'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookName': bookName,
      'arabic': arabic,
      'english': english,
      'reference': reference,
    };
  }
}
