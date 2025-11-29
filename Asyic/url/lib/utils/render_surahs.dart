import 'dart:io';

import 'quran_renderer.dart';

/// Simple script to export all surahs as formatted text files.
/// Run locally (from project root):
///   dart run lib/utils/render_surahs.dart

void main(List<String> args) {
  final outDir = Directory('assets/formatted_surahs');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  // Allow user to specify verses per page via command-line argument
  int versesPerPage = 10; // default
  if (args.isNotEmpty) {
    final parsed = int.tryParse(args[0]);
    if (parsed != null && parsed >= 0) {
      versesPerPage = parsed;
    }
  }

  print('Exporting surahs with $versesPerPage verses per page...');
  final surahs = availableSurahNumbers();
  for (final s in surahs) {
    final pages = formatSurahPages(s, versesPerPage: versesPerPage);
    final file = File('${outDir.path}/surah_${s}.txt');
    final content = StringBuffer();
    for (var i = 0; i < pages.length; i++) {
      content.writeln('--- صفحة ${i + 1} ---\n');
      content.writeln(pages[i]);
      content.writeln('\n\n');
    }
    file.writeAsStringSync(content.toString());
    print('Wrote: ${file.path}');
  }
}
