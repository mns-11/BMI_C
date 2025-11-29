import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hadith/hadith_book_model.dart';

class MuslimHadithService {
  static const String _basePath = 'assets/data/hadiths/muslim';
  static List<HadithBook>? _cachedBooks;

  /// Load all hadith books from the index file
  static Future<List<HadithBook>> loadHadithBooks() async {
    if (_cachedBooks != null) {
      return _cachedBooks!;
    }

    try {
      final String response = await rootBundle.loadString('$_basePath/index.json');
      final List<dynamic> booksList = json.decode(response);
      
      _cachedBooks = [];
      
      for (var bookJson in booksList) {
        try {
          _cachedBooks!.add(HadithBook(
            id: bookJson['id'] as int,
            name: bookJson['name'] as String,
            hadithCount: bookJson['hadithCount'] as int,
          ));
        } catch (e) {
          print('Error parsing hadith book ${bookJson['id']}: $e');
        }
      }
      
      if (_cachedBooks!.isEmpty) {
        throw Exception('No hadith books were loaded. Please check the JSON files.');
      }
      
      return _cachedBooks!;
    } catch (e) {
      print('Error loading hadith books: $e');
      rethrow;
    }
  }

  /// Load hadiths for a specific book
  static Future<HadithBook> loadHadithsForBook(int bookId) async {
    try {
      // First get the book info
      final books = await loadHadithBooks();
      final book = books.firstWhere((b) => b.id == bookId);
      
      // Load the hadiths for this book
      final String response = await rootBundle.loadString('$_basePath/books/$bookId.json');
      final List<dynamic> hadithsList = json.decode(response);
      
      final hadiths = hadithsList.map((h) => Hadith(
        id: h['id'] as int,
        arabicText: h['arabicText'] as String? ?? '',
        englishText: h['englishText'] as String? ?? h['translation'] as String? ?? '',
        reference: h['reference'] as String? ?? '',
        narrator: h['narrator'] as String?,
        source: h['source'] as String?,
        bookName: h['bookName'] as String?,
        bookId: h['bookId'] as int?,
        grade: h['grade'] as String?,
      )).toList();
      
      // Return a new book instance with the loaded hadiths
      return book.copyWith(hadiths: hadiths);
    } catch (e) {
      print('Error loading hadiths for book $bookId: $e');
      rethrow;
    }
  }

  /// Get a single hadith by book and hadith ID
  static Future<Hadith?> getHadith(int bookId, int hadithId) async {
    try {
      final book = await loadHadithsForBook(bookId);
      return book.hadiths?.firstWhere(
        (h) => h.id == hadithId,
        orElse: () => throw Exception('Hadith not found')
      );
    } catch (e) {
      print('Error getting hadith $hadithId from book $bookId: $e');
      return null;
    }
  }
}
