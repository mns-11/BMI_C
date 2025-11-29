import 'package:flutter/material.dart';

import '../utils/quran_renderer.dart';

class SurahView extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  const SurahView({
    Key? key,
    required this.surahNumber,
    required this.surahName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = formatSurahPages(surahNumber, versesPerPage: 0);
    final content = pages.isNotEmpty ? pages[0] : '';

    return Scaffold(
      appBar: AppBar(title: Text('$surahName — $surahNumber')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: SelectableText(
            content,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 20, height: 1.6),
          ),
        ),
      ),
    );
  }
}
