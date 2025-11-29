import 'dart:math' show min;

import 'quran_text_old.dart';

/// Utility to get Sūrat al‑Baqara chunked into pages/chunks.
/// Usage: call `getBaqaraChunks(pageSize: 10)` to get List<List<Map<String,dynamic>>>
List<List<Map<String, dynamic>>> getBaqaraChunks({int pageSize = 10}) {
  final verses = quranTextOld.where((e) => e['surah_number'] == 2).toList();
  final chunks = <List<Map<String, dynamic>>>[];
  for (var i = 0; i < verses.length; i += pageSize) {
    chunks.add(verses.sublist(i, min(i + pageSize, verses.length)));
  }
  return chunks;
}
