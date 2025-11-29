import 'package:flutter/material.dart';
import '../models/muslim_hadith_model.dart';
import '../services/muslim_service.dart';

class MuslimHadithsScreen extends StatefulWidget {
  static const routeName = '/muslim-hadiths';

  const MuslimHadithsScreen({Key? key}) : super(key: key);

  @override
  _MuslimHadithsScreenState createState() => _MuslimHadithsScreenState();
}

class _MuslimHadithsScreenState extends State<MuslimHadithsScreen> {
  late Future<Map<String, List<MuslimHadith>>> _hadithsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  double _fontSize = 16.0; // Default font size for book titles

  @override
  void initState() {
    super.initState();
    _hadithsFuture = MuslimService.getHadithsByBook();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to increase font size
  void _increaseFontSize() {
    setState(() {
      _fontSize = _fontSize < 24.0 ? _fontSize + 2.0 : _fontSize;
    });
  }

  // Method to decrease font size
  void _decreaseFontSize() {
    setState(() {
      _fontSize = _fontSize > 12.0 ? _fontSize - 2.0 : _fontSize;
    });
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
        backgroundColor: Colors.blue[800],
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'ابحث في صحيح مسلم...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => _onSearchChanged(),
              )
            : const Text('صحيح مسلم'),
        centerTitle: true,
        actions: [
          // Add font scaling buttons
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
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
      body: FutureBuilder<Map<String, List<MuslimHadith>>>(
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
            return const Center(child: Text('لا توجد أحاديث متاحة'));
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
                    style: TextStyle(
                      fontSize: _fontSize + 8, // Use dynamic font size
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    'عدد الأحاديث: ${hadiths.length}',
                    style: TextStyle(
                      fontSize: _fontSize,
                    ), // Use dynamic font size
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MuslimBookHadithsScreen(
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

  Widget _buildSearchResults(Map<String, List<MuslimHadith>> books) {
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
            title: Text(
              hadith.arabicText,
              style: TextStyle(fontSize: _fontSize), // Use dynamic font size
            ),
            subtitle: Text(
              hadith.bookName,
              style: TextStyle(
                fontSize: _fontSize - 2,
              ), // Use dynamic font size
            ),
            onTap: () {
              // Show full hadith in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    '${hadith.bookName} - حديث ${hadith.id}',
                    style: TextStyle(
                      fontSize: _fontSize + 2,
                    ), // Use dynamic font size
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      hadith.arabicText,
                      style: TextStyle(
                        fontSize: _fontSize + 2,
                      ), // Use dynamic font size
                    ),
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

class MuslimBookHadithsScreen extends StatefulWidget {
  final String bookName;
  final List<MuslimHadith> hadiths;

  const MuslimBookHadithsScreen({
    Key? key,
    required this.bookName,
    required this.hadiths,
  }) : super(key: key);

  @override
  _MuslimBookHadithsScreenState createState() =>
      _MuslimBookHadithsScreenState();
}

class _MuslimBookHadithsScreenState extends State<MuslimBookHadithsScreen> {
  double _fontSize = 16.0; // Default font size

  void _increaseFontSize() {
    setState(() {
      _fontSize = _fontSize < 24.0 ? _fontSize + 2.0 : _fontSize;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize = _fontSize > 12.0 ? _fontSize - 2.0 : _fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        actions: [
          // Add font size controls to AppBar
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.hadiths.length,
        itemBuilder: (context, index) {
          final hadith = widget.hadiths[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                hadith.arabicText,
                style: TextStyle(fontSize: _fontSize),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                'الحديث رقم: ${index + 1}',
                style: TextStyle(fontSize: _fontSize - 2),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      '${widget.bookName} - حديث ${index + 1}',
                      style: TextStyle(fontSize: _fontSize + 2),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            hadith.arabicText,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: _fontSize + 2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hadith.englishText,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hadith.reference,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
