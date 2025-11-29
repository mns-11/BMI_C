import 'package:flutter/material.dart';
import '../models/tirmidhi_hadith_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TirmidhiService {
  static const String _dataPath = 'assets/data/hadiths/tirmidhi_data.json';

  static Future<List<TirmidhiHadith>> getAllHadiths() async {
    try {
      debugPrint('Loading Tirmidhi data from $_dataPath');
      // Load data from JSON file
      final String jsonString = await rootBundle.loadString(_dataPath);
      debugPrint('Loaded JSON string with length: ${jsonString.length}');

      final List<dynamic> jsonData = json.decode(jsonString);
      debugPrint('Parsed JSON data with ${jsonData.length} items');

      final result = jsonData
          .map((item) => TirmidhiHadith.fromJson(item))
          .toList();
      debugPrint('Converted to ${result.length} TirmidhiHadith objects');

      return result;
    } catch (e, stackTrace) {
      debugPrint('Error loading Tirmidhi hadiths: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return sample data if there's an error
      return _getSampleData();
    }
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    try {
      final hadiths = await getAllHadiths();
      debugPrint('Grouping ${hadiths.length} hadiths by book');
      final books = <String, Map<String, dynamic>>{};

      // Group hadiths by book
      for (final hadith in hadiths) {
        if (!books.containsKey(hadith.bookName)) {
          books[hadith.bookName] = {'name': hadith.bookName, 'count': 0};
        }
        books[hadith.bookName]!['count'] = books[hadith.bookName]!['count'] + 1;
      }

      final result = books.values.toList();
      debugPrint('Found ${result.length} books');
      return result;
    } catch (e, stackTrace) {
      debugPrint('Error grouping books: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<List<TirmidhiHadith>> getHadithsByBook(String bookName) async {
    try {
      final allHadiths = await getAllHadiths();
      debugPrint('Filtering hadiths for book: $bookName');
      final result = allHadiths
          .where((hadith) => hadith.bookName == bookName)
          .toList();
      debugPrint('Found ${result.length} hadiths for book: $bookName');
      return result;
    } catch (e, stackTrace) {
      debugPrint('Error filtering hadiths by book: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  // Sample data for demonstration
  static List<TirmidhiHadith> _getSampleData() {
    debugPrint('Returning sample data');
    return [
      TirmidhiHadith(
        id: 1,
        bookName: 'كتاب الطهارة',
        bookNumber: 1,
        arabicText:
            'عن عثمان بن عفان رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: من توضأ مثل طهوري هذا ثم صلى ركعتين لا يلهيهما شيء غفر له ما تقدم من ذنبه وما تأخر',
        englishText:
            'Uthman ibn Affan (May Allah be pleased with him) reported: Messenger of Allah (PBUH) said, "Whoever performs ablution as I do and then prays two rak\'ahs without letting his mind wander, his past sins will be forgiven."',
        reference: 'سنن الترمذي - كتاب الطهارة - حديث 1',
      ),
      TirmidhiHadith(
        id: 2,
        bookName: 'كتاب الطهارة',
        bookNumber: 1,
        arabicText:
            'عن أبي أيوب الأنصاري رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: لو أنكم تعلمون ما في الآذان والمسح على الرؤوس ما تمسحوا عليهما لأحببتموه',
        englishText:
            'Abu Ayyub Al-Ansari (May Allah be pleased with him) reported: Messenger of Allah (PBUH) said, "If you knew what is in the ears and what is in stroking the heads, you would love it."',
        reference: 'سنن الترمذي - كتاب الطهارة - حديث 2',
      ),
      TirmidhiHadith(
        id: 3,
        bookName: 'كتاب الصلاة',
        bookNumber: 2,
        arabicText:
            'عن أبي هريرة رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: من صلى العصر فقد صلى ما قبلها ومن فاته العصر حتى تطلع الشمس أو تغرب فقد فاته العصر',
        englishText:
            'Abu Hurairah (May Allah be pleased with him) reported: Messenger of Allah (PBUH) said, "Whoever performs the \'Asr prayer, it is as if he has performed all the previous prayers. Whoever misses the \'Asr prayer until the sun rises or sets, he has missed the \'Asr prayer."',
        reference: 'سنن الترمذي - كتاب الصلاة - حديث 3',
      ),
    ];
  }
}
