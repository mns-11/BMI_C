import 'package:flutter/material.dart';

import '../utils/quran_text_old.dart';
import '../utils/surah_names.dart';
import '../screens/surah_view.dart';

/// A responsive grid of cards showing the surahs.
class SurahCards extends StatelessWidget {
  final Axis scrollDirection;
  const SurahCards({Key? key, this.scrollDirection = Axis.vertical}) : super(key: key);

  int _verseCount(int surahNumber) {
    return quranTextOld.where((e) => e['surah_number'] == surahNumber).length;
  }

  @override
  Widget build(BuildContext context) {
    // The dataset contains surahs by number, but we'll show 1..114
    const total = 114;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: total,
      itemBuilder: (context, index) {
        final surahNo = index + 1;
        final name = surahNames.length > surahNo ? surahNames[surahNo] : 'سورة $surahNo';
        final verses = _verseCount(surahNo);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SurahView(surahNumber: surahNo, surahName: name),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          surahNo.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$verses آية',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
