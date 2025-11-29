import 'package:flutter/material.dart';
import '../../models/hadith/hadith_book_model.dart';
import '../../services/muslim_hadith_service.dart';
import 'hadith_list_screen.dart';

class MuslimBooksScreen extends StatefulWidget {
  const MuslimBooksScreen({Key? key}) : super(key: key);

  @override
  _MuslimBooksScreenState createState() => _MuslimBooksScreenState();
}

class _MuslimBooksScreenState extends State<MuslimBooksScreen> {
  late Future<List<HadithBook>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = MuslimHadithService.loadHadithBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5), // Match the blue color
        title: const Text(
          'صحيح مسلم',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<HadithBook>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد كتب متاحة'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    book.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    'عدد الأحاديث: ${book.hadithCount}',
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HadithListScreen(
                          bookId: book.id,
                          bookName: book.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
