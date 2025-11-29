import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BukhariHadiths {
  static const String _basePath = 'assets/hadiths/bukhari/';
  
  static Future<Map<String, List<Map<String, dynamic>>>> getBukhariHadiths() async {
    try {
      // Load the main index of Bukhari hadiths
      final String indexJson = await rootBundle.loadString('${_basePath}index.json');
      final Map<String, dynamic> index = json.decode(indexJson);
      
      final Map<String, List<Map<String, dynamic>>> hadithsByBook = {};
      
      // Load each book's hadiths
      for (final book in index['books']) {
        final String bookId = book['id'];
        final String bookTitle = book['title'];
        
        try {
          final String bookJson = await rootBundle.loadString('${_basePath}books/$bookId.json');
          final Map<String, dynamic> bookData = json.decode(bookJson);
          
          hadithsByBook[bookTitle] = [];
          
          // Process each hadith in the book
          for (final hadith in bookData['hadiths']) {
            hadithsByBook[bookTitle]!.add({
              'id': hadith['hadithNumber'],
              'title': 'حديث رقم ${hadith['hadithNumber']}',
              'content': hadith['arabic'],
              'reference': 'صحيح البخاري - كتاب ${bookTitle} - حديث رقم ${hadith['hadithNumber']}',
              'book': bookTitle,
              'bookId': bookId,
              'hadithNumber': hadith['hadithNumber'],
            });
          }
        } catch (e) {
          print('Error loading book $bookId: $e');
        }
      }
      
      return hadithsByBook;
    } catch (e) {
      print('Error loading Bukhari hadiths: $e');
      return {};
    }
  }
  
  // Get sample hadiths for testing
  static Map<String, List<Map<String, dynamic>>> getSampleBukhariHadiths() {
    return {
      'كتاب الإيمان': [
        {
          'id': 1,
          'title': 'حديث رقم 1',
          'content': 'بَابُ مَا جَاءَ أَنَّ الأَعْمَالَ بِالنِّيَّةِ وَالْحِسْبَةِ، وَلِكُلِّ امْرِئٍ مَا نَوَى',
          'reference': 'صحيح البخاري - كتاب الإيمان - حديث رقم 1',
          'book': 'كتاب الإيمان',
          'bookId': '1',
          'hadithNumber': 1,
        },
        {
          'id': 2,
          'title': 'حديث رقم 2',
          'content': 'بَابُ دُعَاؤُكُمْ إِيمَانُكُمْ',
          'reference': 'صحيح البخاري - كتاب الإيمان - حديث رقم 2',
          'book': 'كتاب الإيمان',
          'bookId': '1',
          'hadithNumber': 2,
        },
      ],
      'كتاب العلم': [
        {
          'id': 101,
          'title': 'حديث رقم 1',
          'content': 'بَابُ فَضْلِ الْعِلْمِ',
          'reference': 'صحيح البخاري - كتاب العلم - حديث رقم 1',
          'book': 'كتاب العلم',
          'bookId': '3',
          'hadithNumber': 1,
        },
      ],
    };
  }
}
