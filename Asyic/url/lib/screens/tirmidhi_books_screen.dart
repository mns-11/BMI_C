import 'package:flutter/material.dart';
import '../models/tirmidhi_hadith_model.dart';
import '../services/tirmidhi_service.dart';

class TirmidhiBooksScreen extends StatefulWidget {
  static const String routeName = '/tirmidhi-books';

  @override
  _TirmidhiBooksScreenState createState() => _TirmidhiBooksScreenState();
}

class _TirmidhiBooksScreenState extends State<TirmidhiBooksScreen> {
  late Future<List<Map<String, dynamic>>> _booksFuture;
  List<Map<String, dynamic>> _allBooks = [];
  List<Map<String, dynamic>> _filteredBooks = [];
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
            .where(
              (book) => book['name'].toString().toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  Future<void> _loadBooks() async {
    _booksFuture = TirmidhiService.getBooks();
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
          'كتب سنن الترمذي',
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
                delegate: _TirmidhiBookSearchDelegate(_allBooks),
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                            book['name'].toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: _fontSize + 2, // Use dynamic font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${book['count']} أحاديث',
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
                                builder: (context) => TirmidhiBookDetailScreen(
                                  bookName: book['name'].toString(),
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

class _TirmidhiBookSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> books;

  _TirmidhiBookSearchDelegate(this.books);

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
        .where(
          (book) => book['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book['name'].toString()),
          subtitle: Text('${book['count']} أحاديث'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TirmidhiBookDetailScreen(bookName: book['name'].toString()),
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
        .where(
          (book) => book['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          title: Text(book['name'].toString()),
          subtitle: Text('${book['count']} أحاديث'),
          onTap: () {
            query = book['name'].toString();
            showResults(context);
          },
        );
      },
    );
  }
}

// Tirmidhi Book Detail Screen
class TirmidhiBookDetailScreen extends StatefulWidget {
  final String bookName;
  final double initialFontSize; // Add font size parameter

  TirmidhiBookDetailScreen({
    required this.bookName,
    this.initialFontSize = 16.0,
  });

  @override
  _TirmidhiBookDetailScreenState createState() =>
      _TirmidhiBookDetailScreenState();
}

class _TirmidhiBookDetailScreenState extends State<TirmidhiBookDetailScreen> {
  late Future<List<TirmidhiHadith>> _hadithsFuture;
  double _fontSize = 16.0; // Default font size

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize; // Initialize with passed font size
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    _hadithsFuture = TirmidhiService.getHadithsByBook(widget.bookName);
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
      body: FutureBuilder<List<TirmidhiHadith>>(
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
                      hadith.arabicText,
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
                          hadith.englishText,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: _fontSize - 2,
                            color: Colors.grey[600],
                          ), // Use dynamic font size
                        ),
                        SizedBox(height: 4),
                        Text(
                          hadith.reference,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: _fontSize - 4,
                            color: Colors.grey[500],
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

  void _showHadithDetail(BuildContext context, TirmidhiHadith hadith) {
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
                  hadith.arabicText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: _fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ), // Use dynamic font size
                ),
                SizedBox(height: 16),
                Text(
                  hadith.englishText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: _fontSize,
                  ), // Use dynamic font size
                ),
                SizedBox(height: 16),
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
