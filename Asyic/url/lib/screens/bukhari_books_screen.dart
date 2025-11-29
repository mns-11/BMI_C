import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BukhariHadith {
  final int id;
  final String arabic;
  final String reference;

  BukhariHadith({
    required this.id,
    required this.arabic,
    required this.reference,
  });

  factory BukhariHadith.fromJson(Map<String, dynamic> json) {
    return BukhariHadith(
      id: json['id'],
      arabic: json['arabic'],
      reference: json['reference'],
    );
  }
}

class BukhariBook {
  final String id;
  final String title;
  final int hadithCount;

  BukhariBook({
    required this.id,
    required this.title,
    required this.hadithCount,
  });

  factory BukhariBook.fromJson(Map<String, dynamic> json) {
    return BukhariBook(
      id: json['id'],
      title: json['title'],
      hadithCount: json['hadithCount'],
    );
  }
}

class BukhariService {
  static const String _basePath = 'assets/hadiths/bukhari';

  static Future<List<BukhariBook>> getBooks() async {
    try {
      final String jsonString = await rootBundle.loadString(
        '$_basePath/index.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> booksJson = jsonData['books'];

      return booksJson.map((book) => BukhariBook.fromJson(book)).toList();
    } catch (e) {
      debugPrint('Error loading Bukhari books: $e');
      return [];
    }
  }

  static Future<List<BukhariHadith>> getHadithsByBook(String bookId) async {
    try {
      final String jsonString = await rootBundle.loadString(
        '$_basePath/books/$bookId.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> hadithsJson = jsonData['hadiths'];

      return hadithsJson
          .map((hadith) => BukhariHadith.fromJson(hadith))
          .toList();
    } catch (e) {
      debugPrint('Error loading Bukhari hadiths for book $bookId: $e');
      return [];
    }
  }
}

class BukhariBooksScreen extends StatefulWidget {
  static const String routeName = '/bukhari-books';

  @override
  _BukhariBooksScreenState createState() => _BukhariBooksScreenState();
}

class _BukhariBooksScreenState extends State<BukhariBooksScreen> {
  late Future<List<BukhariBook>> _booksFuture;
  List<BukhariBook> _allBooks = [];
  List<BukhariBook> _filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();
  double _fontSize = 16.0; // Default font size

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
    final query = _searchController.text.toLowerCase();
    _filterBooks(query);
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = List.from(_allBooks);
      } else {
        _filteredBooks = _allBooks
            .where((book) => book.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _loadBooks() async {
    _booksFuture = BukhariService.getBooks();
    try {
      final books = await _booksFuture;
      setState(() {
        _allBooks = books;
        _filteredBooks = List.from(books);
      });
    } catch (e) {
      // Handle error
      setState(() {
        _allBooks = [];
        _filteredBooks = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'كتب صحيح البخاري',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Add font scaling buttons
          IconButton(
            icon: Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _BukhariBookSearchDelegate(_allBooks),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن كتاب...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Books list
          Expanded(
            child: FutureBuilder<List<BukhariBook>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ أثناء تحميل الكتب'));
                } else if (_filteredBooks.isEmpty) {
                  return Center(child: Text('لا توجد كتب'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            book.title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: _fontSize + 2, // Use dynamic font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${book.hadithCount} أحاديث',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: _fontSize,
                            ), // Use dynamic font size
                          ),
                          leading: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.green,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BukhariBookDetailScreen(
                                  bookId: book.id,
                                  bookName: book.title,
                                  initialFontSize:
                                      _fontSize, // Pass font size to detail screen
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BukhariBookSearchDelegate extends SearchDelegate<String> {
  final List<BukhariBook> books;

  _BukhariBookSearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text('${book.hadithCount} أحاديث'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BukhariBookDetailScreen(
                  bookId: book.id,
                  bookName: book.title,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text('${book.hadithCount} أحاديث'),
          onTap: () {
            query = book.title;
            showResults(context);
          },
        );
      },
    );
  }
}

// Bukhari Book Detail Screen
class BukhariBookDetailScreen extends StatefulWidget {
  final String bookId;
  final String bookName;
  final double initialFontSize; // Add font size parameter

  BukhariBookDetailScreen({
    required this.bookId,
    required this.bookName,
    this.initialFontSize = 16.0,
  });

  @override
  _BukhariBookDetailScreenState createState() =>
      _BukhariBookDetailScreenState();
}

class _BukhariBookDetailScreenState extends State<BukhariBookDetailScreen> {
  late Future<List<BukhariHadith>> _hadithsFuture;
  double _fontSize = 16.0; // Default font size

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize; // Initialize with passed font size
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    _hadithsFuture = BukhariService.getHadithsByBook(widget.bookId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName, style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          // Add font scaling buttons
          IconButton(
            icon: Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: FutureBuilder<List<BukhariHadith>>(
        future: _hadithsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء تحميل الأحاديث'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد أحاديث في هذا الكتاب'));
          } else {
            final hadiths = snapshot.data!;
            return ListView.builder(
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      hadith.arabic,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: _fontSize,
                      ), // Use dynamic font size
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          hadith.reference,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: _fontSize - 2,
                            color: Colors.grey[600],
                          ), // Use dynamic font size
                        ),
                      ],
                    ),
                    onTap: () {
                      _showHadithDetail(context, hadith);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showHadithDetail(BuildContext context, BukhariHadith hadith) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حديث رقم ${hadith.id}', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hadith.arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: _fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ), // Use dynamic font size
                ),
                SizedBox(height: 16),
                Text(
                  hadith.reference,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.grey[600],
                  ), // Use dynamic font size
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}
