class VerseModel {
  final int verseNumber;
  final String text;
  final String qcf;
  String get qcfTrimmed {
    return qcf.substring(0, qcf.lastIndexOf(' ')) + qcf[qcf.length - 1];
  }

  String get qcfNoVerseNumber {
    return qcf.substring(0, qcf.lastIndexOf(' '));
  }

  String get verseNumberAsQcf => qcf[qcf.length - 1];

  VerseModel({
    required this.verseNumber,
    required this.text,
    required this.qcf,
  });
}
