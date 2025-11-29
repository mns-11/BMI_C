// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import '../models/bukhari_hadith_model.dart';

// class BukhariService {
//   static const String _basePath = 'assets/hadiths/bukhari';
  
//   // Load all Bukhari hadiths
//   static Future<List<BukhariHadith>> loadHadiths() async {
//     try {
//       // Load the index file to get list of books
//       final String indexJson = await rootBundle.loadString('$_basePath/index.json');
//       final Map<String, dynamic> indexData = json.decode(indexJson);
      
//       List<BukhariHadith> allHadiths = [];
      
//       // Load each book's hadiths
//       for (var book in indexData['books']) {
//         final String bookId = book['id'].toString();
//         final String bookName = book['name_ar'];
        
//         try {
//           final String bookJson = await rootBundle.loadString('$_basePath/books/$bookId.json');
//           final Map<String, dynamic> bookData = json.decode(bookJson);
          
//           // Process each hadith in the book
//           for (var hadith in bookData['hadiths']) {
//             allHadiths.add(BukhariHadith(
//               id: hadith['hadithNumber'],
//               bookId: int.parse(bookId),
//               bookName: bookName,
//               arabic: hadith['arabic'],
//               reference: 'صحيح البخاري - $bookName - حديث رقم ${hadith['hadithNumber']}',
//             ));
//           }
//         } catch (e) {
//           print('Error loading book $bookId: $e');
//           continue;
//         }
//       }
      
//       return allHadiths;
      
//     } catch (e) {
//       print('Error loading Bukhari hadiths: $e');
//       return [];
//     }
//   }
  
//   // Get hadiths by book
//   static Future<Map<String, List<BukhariHadith>>> getHadithsByBook() async {
//     final hadiths = await loadHadiths();
//     final Map<String, List<BukhariHadith>> bookMap = {};
    
//     for (var hadith in hadiths) {
//       bookMap.putIfAbsent(hadith.bookName, () => []).add(hadith);
//     }
    
//     return bookMap;
//   }
  
//   // Get sample hadiths for testing
//   static List<BukhariHadith> getSampleHadiths() {
//     return [
//       BukhariHadith(
//         id: 1,
//         bookId: 1,
//         bookName: 'كتاب بدء الوحي',
//         arabic: 'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى...',
//         reference: 'صحيح البخاري - كتاب بدء الوحي - حديث رقم 1',
//       ),
//       BukhariHadith(
//         id: 2,
//         bookId: 2,
//         bookName: 'كتاب الإيمان',
//         arabic: 'بني الإسلام على خمس...',
//         reference: 'صحيح البخاري - كتاب الإيمان - حديث رقم 8',
//       ),
//     ];
//   }
// }
