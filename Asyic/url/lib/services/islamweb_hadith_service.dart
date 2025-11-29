import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

/// Service for fetching hadiths from Islamweb.net
/// Note: This service requires internet connection to fetch data

class IslamwebHadithService {
  static const String _baseUrl = 'https://www.islamweb.net';

  // Get main hadith collections
  static Future<List<Map<String, dynamic>>> getHadithCollections() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/ar/articles/416/%D9%83%D8%AA%D8%A8-%D8%A7%D9%84%D8%B5%D8%AD%D8%A7%D8%AD',
            ),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
              'Accept':
                  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
              'Accept-Language': 'en-US,en;q=0.5',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final articles = document.querySelectorAll('article');

        return articles.map((article) {
          final titleElement = article.querySelector('h2 a');
          final link = titleElement?.attributes['href'] ?? '';
          final title = titleElement?.text.trim() ?? 'حديث';

          return {
            'title': title,
            'url': link,
            'description':
                article.querySelector('.article-content')?.text.trim() ?? '',
          };
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching hadith collections: $e');
      return [];
    }
  }

  // Get hadiths from a specific collection
  static Future<List<Map<String, dynamic>>> getHadithsFromCollection(
    String collectionUrl,
  ) async {
    try {
      if (!collectionUrl.startsWith('http')) {
        collectionUrl = '$_baseUrl$collectionUrl';
      }

      final response = await http.get(
        Uri.parse(collectionUrl),
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final hadiths = <Map<String, dynamic>>[];

        // This is a simplified example - you'll need to adjust the selectors
        // based on the actual structure of the hadith pages
        final hadithElements = document.querySelectorAll('.hadith-item');

        for (var i = 0; i < hadithElements.length; i++) {
          final element = hadithElements[i];
          hadiths.add({
            'id': i + 1,
            'title': 'حديث ${i + 1}',
            'content': element.querySelector('.hadith-text')?.text.trim() ?? '',
            'reference':
                element.querySelector('.hadith-reference')?.text.trim() ?? '',
          });
        }

        return hadiths;
      }
      return [];
    } catch (e) {
      print('Error fetching hadiths: $e');
      return [];
    }
  }

  // Get sample hadiths (fallback)
  static List<Map<String, dynamic>> getSampleHadiths() {
    return [
      // {
      //   'id': 1,
      //   'title': 'حديث شريف',
      //   'content': 'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى',
      //   'reference': 'صحيح البخاري',
      // },
      {
        'id': 2,
        'title': 'حديث شريف',
        'content': 'الدين النصيحة',
        'reference': 'صحيح مسلم',
      },
    ];
  }
}
