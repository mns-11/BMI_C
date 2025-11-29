import 'package:flutter/material.dart';
import '../../../models/quran/surah_model.dart';

class SurahAlfatihaWidget extends StatelessWidget {
  final SurahModel surah;

  const SurahAlfatihaWidget(this.surah, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('صفحة الفاتحة'),
    );
  }
}