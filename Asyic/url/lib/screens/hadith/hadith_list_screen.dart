import 'package:flutter/material.dart';
import '../../models/hadith/hadith_book_model.dart';
import '../../services/muslim_hadith_service.dart';

class HadithListScreen extends StatefulWidget {
  final int bookId;
  final String bookName;

  const HadithListScreen({
    Key? key,
    required this.bookId,
    required this.bookName,
  }) : super(key: key);

  @override
  _HadithListScreenState createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  late Future<HadithBook> _hadithsFuture;

  @override
  void initState() {
    super.initState();
    _hadithsFuture = MuslimHadithService.loadHadithsForBook(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5), // Blue color
        title: Text(
          widget.bookName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<HadithBook>(
        future: _hadithsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.hadiths == null) {
            return const Center(child: Text('لا توجد أحاديث متاحة'));
          }

          final hadiths = snapshot.data!.hadiths!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: hadiths.length,
            itemBuilder: (context, index) {
              final hadith = hadiths[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        hadith.arabicText,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Amiri', // Use a nice Arabic font
                        ),
                      ),
                      if (hadith.englishText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          hadith.englishText,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (hadith.narrator != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'عن ${hadith.narrator}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
