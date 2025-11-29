import 'quran_text_old.dart';

/// Small renderer utilities to format Quran verses per-surah.
/// Assumptions:
/// - `quranTextOld` is a List<Map<String,dynamic>> with keys: surah_number, verse_number, content.
/// - Surah names are not present in the data, so we label by surah number (e.g. "سورة 2").
///
/// Usage:
/// - call `formatSurahPages(2, versesPerPage: 0)` to get a single-page formatted Surah 2 (no pagination)
/// - call `formatSurahPages(2, versesPerPage: 10)` to get pages with 10 verses each.

String _toArabicIndic(int n) {
  // convert integer to Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩)
  final digits = n.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final d = digits.codeUnitAt(i) - 48; // '0' = 48
    final arabicIndic = String.fromCharCode(0x06F0 + d);
    buffer.write(arabicIndic);
  }
  return buffer.toString();
}

String _verseMarker(int verseNumber) => ' (${_toArabicIndic(verseNumber)})';

/// Return the list of verses for a surah (ordered by verse_number).
List<Map<String, dynamic>> getSurahVerses(int surahNumber) {
  final verses = quranTextOld
      .where((e) => e['surah_number'] == surahNumber)
      .toList(growable: false);
  verses.sort((a, b) => (a['verse_number'] as int).compareTo(b['verse_number'] as int));
  return verses;
}

/// Format a single surah into pages. If versesPerPage == 0, returns a single element list (no pagination).
List<String> formatSurahPages(int surahNumber, {int versesPerPage = 0}) {
  final verses = getSurahVerses(surahNumber);
  final header = 'سورة $surahNumber';

  // Build formatted lines for each verse: content + verse marker (Arabic-Indic)
  final formattedVerses = verses
      .map((v) => '${v['content']}${_verseMarker(v['verse_number'] as int)}')
      .toList(growable: false);

  if (versesPerPage == 0) {
    // whole surah as single page
    final page = StringBuffer();
    page.writeln(header);
    page.writeln('');
    for (final line in formattedVerses) {
      page.writeln(line);
      page.writeln(''); // blank line between verses for readability
    }
    return [page.toString()];
  }

  final pages = <String>[];
  for (var i = 0; i < formattedVerses.length; i += versesPerPage) {
    final sub = formattedVerses.sublist(i, (i + versesPerPage).clamp(0, formattedVerses.length));
    final page = StringBuffer();
    page.writeln(header + ' — صفحة ${_toArabicIndic((i ~/ versesPerPage) + 1)}');
    page.writeln('');
    for (final line in sub) {
      page.writeln(line);
      page.writeln('');
    }
    pages.add(page.toString());
  }
  return pages;
}

/// Provide a convenience to iterate all available surah numbers in the dataset.
List<int> availableSurahNumbers() {
  final set = <int>{};
  for (final e in quranTextOld) {
    set.add(e['surah_number'] as int);
  }
  final list = set.toList()..sort();
  return list;
}
