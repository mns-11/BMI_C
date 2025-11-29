import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class AnasHadithsService {
  static const String _baseUrl = 'https://www.islamweb.net';

  // Get hadiths from Anas bin Malik
  static Future<List<Map<String, dynamic>>> getAnasHadiths() async {
    try {
      // This is a sample URL - replace with actual URL for Anas bin Malik's hadiths
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/ar/articles/172/%D8%A7%D9%84%D8%AD%D8%AF%D9%8A%D8%AB-%D8%A7%D9%84%D8%B4%D8%B1%D9%8A%D9%81',
        ),
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final hadiths = <Map<String, dynamic>>[];

        // Extract hadiths from the page
        // Note: You'll need to adjust these selectors based on the actual page structure
        final hadithElements = document.querySelectorAll('.hadith-item');

        for (var i = 0; i < hadithElements.length; i++) {
          final element = hadithElements[i];
          hadiths.add({
            'id': i + 1,
            'title': 'حديث أنس بن مالك ${i + 1}',
            'content': element.text.trim(),
            'reference': 'مسند أنس بن مالك',
            'book': 'السنة النبوية',
          });
        }

        // If no hadiths found, return sample data
        if (hadiths.isEmpty) {
          return getSampleHadiths();
        }

        return hadiths;
      }
      return getSampleHadiths();
    } catch (e) {
      print('Error fetching Anas hadiths: $e');
      return getSampleHadiths();
    }
  }

  // Sample hadiths for offline use
  static List<Map<String, dynamic>> getSampleHadiths() {
    return [
      // {
      //   'id': 1,
      //   'title': 'حديث أنس بن مالك 1',
      //   'content': 'عن أنس بن مالك رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: "لا يؤمن أحدكم حتى يحب لأخيه ما يحب لنفسه"',
      //   'reference': 'صحيح البخاري',
      //   'book': 'السنة النبوية',
      // },
      // {
      //   'id': 2,
      //   'title': 'حديث أنس بن مالك 2',
      //   'content': 'عن أنس بن مالك رضي الله عنه قال: خدمت النبي صلى الله عليه وسلم عشر سنين، فما قال لي أف قط، ولا قال لشيء فعلته لم فعلته، ولا لشيء لم أفعله ألا فعلت كذا',
      //   'reference': 'صحيح البخاري',
      //   'book': 'السنة النبوية',
      // },
      // Add more sample hadiths as needed
    ];
  }
}
