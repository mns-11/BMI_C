import 'package:flutter/material.dart';

class HadithDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hadith;

  const HadithDetailScreen({Key? key, required this.hadith}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hadith['title'] ?? 'تفاصيل الحديث',
          style: const TextStyle(fontFamily: 'UthmanicHafs'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hadith['title'] ?? 'حديث شريف',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'UthmanicHafs',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hadith['content'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.8,
                        fontFamily: 'UthmanicHafs',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    if (hadith['reference'] != null)
                      Text(
                        'المرجع: ${hadith['reference']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'UthmanicHafs',
                        ),
                        textAlign: TextAlign.left,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add share and copy buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الحديث')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('نسخ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم مشاركة الحديث')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('مشاركة'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
