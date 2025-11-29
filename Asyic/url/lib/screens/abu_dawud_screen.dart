import 'package:flutter/material.dart';
import '../models/abu_dawud_hadith_model.dart';
import '../services/abu_dawud_service.dart';
import 'abu_dawud_book_screen.dart';

class AbuDawudScreen extends StatefulWidget {
  static const routeName = '/abu-dawud';

  const AbuDawudScreen({Key? key}) : super(key: key);

  @override
  _AbuDawudScreenState createState() => _AbuDawudScreenState();
}

class _AbuDawudScreenState extends State<AbuDawudScreen> {
  late Future<Map<String, List<AbuDawudHadith>>> _hadithsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _hadithsFuture = AbuDawudService.getHadithsByBook();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'ابحث في سنن أبي داود...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => _onSearchChanged(),
              )
            : const Text('سنن أبي داود'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _onSearchChanged();
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<AbuDawudHadith>>>(
        future: _hadithsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ في تحميل الأحاديث: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد أحاديث متاحة حالياً',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'جارٍ العمل على إضافة المحتوى',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final books = snapshot.data!;

          // If searching, show search results
          if (_searchQuery.isNotEmpty) {
            return _buildSearchResults(books);
          }

          // Otherwise show books list
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final bookName = books.keys.elementAt(index);
              final hadiths = books[bookName]!;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.arrow_back_ios),
                  title: Text(
                    bookName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    'عدد الأحاديث: ${hadiths.length}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    // TODO: Navigate to book details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AbuDawudBookScreen(
                          bookName: bookName,
                          hadiths: hadiths,
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

  Widget _buildSearchResults(Map<String, List<AbuDawudHadith>> books) {
    final allHadiths = books.values.expand((h) => h).toList();
    final results = allHadiths
        .where(
          (hadith) =>
              hadith.arabicText.contains(_searchQuery) ||
              hadith.englishText.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text('لا توجد نتائج'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final hadith = results[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(hadith.arabicText),
            subtitle: Text(hadith.bookName),
            onTap: () {
              // Show full hadith in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('${hadith.bookName} - حديث ${hadith.id}'),
                  content: SingleChildScrollView(
                    child: Text(hadith.arabicText),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
