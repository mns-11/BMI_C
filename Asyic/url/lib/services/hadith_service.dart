import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'bukhari_hadiths.dart';
import 'islamweb_hadith_service.dart';

/// Service for managing hadiths from various sources

class HadithService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/rn0x/Adhkar-json/main';

  // Fetch hadiths from local assets (faster and more reliable)
  static Future<List<Map<String, dynamic>>> fetchHadiths() async {
    try {
      // First try to load from Bukhari hadiths
      try {
        final bukhariHadiths = await BukhariHadiths.getBukhariHadiths();
        if (bukhariHadiths.isNotEmpty) {
          return bukhariHadiths.values.expand((h) => h).toList();
        }
      } catch (e) {
        print('Error loading Bukhari hadiths: $e');
      }
      
      // Then try to load from local assets
      try {
        final String response = await rootBundle.loadString(
          'assets/hadiths.json',
        );
        final List<dynamic> data = json.decode(response);
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        print('Error loading local hadiths.json: $e');
      }
      
      // If local file not found, fetch from GitHub as last resort
      try {
        final response = await http
            .get(Uri.parse('$_baseUrl/adhkar.json'))
            .timeout(const Duration(seconds: 10));
            
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return List<Map<String, dynamic>>.from(data);
        } else {
          print('Failed to load hadiths from GitHub: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching hadiths from GitHub: $e');
      }
      
      // If all else fails, return sample data
      return getSampleHadiths();
    } catch (e) {
      print('Unexpected error in fetchHadiths: $e');
      return getSampleHadiths();
    }
  }

  static List<Map<String, dynamic>> getSampleHadiths() {
    return [
      // {
      //   'id': 1,
      //   'title': 'حديث شريف',
      //   'content': 'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى',
      //   'reference': 'صحيح البخاري',
      //   'category': 'أحاديث نبوية',
      // },
      {
        'id': 2,
        'title': 'حديث شريف',
        'content': 'الدين النصيحة',
        'reference': 'صحيح مسلم',
        'category': 'أحاديث نبوية',
      },
    ];
  }

  static Future<Map<String, List<Map<String, dynamic>>>> getHadithsByCategory() async {
    final Map<String, List<Map<String, dynamic>>> categorized = {};
    
    // Try to load from Bukhari hadiths first (local)
    try {
      final bukhariHadiths = await BukhariHadiths.getBukhariHadiths();
      if (bukhariHadiths.isNotEmpty) {
        categorized.addAll(bukhariHadiths);
      } else {
        // If no Bukhari hadiths, try the sample data
        categorized['صحيح البخاري'] = BukhariHadiths.getSampleBukhariHadiths()['كتاب الإيمان'] ?? [];
      }
    } catch (e) {
      print('Error loading Bukhari hadiths: $e');
    }
    
    // If we still don't have any hadiths, try online sources
    if (categorized.isEmpty) {
      // Try to load hadiths from Islamweb.net
      try {
        final collections = await IslamwebHadithService.getHadithCollections()
            .timeout(const Duration(seconds: 10));
        
        // Add each collection as a category
        for (var collection in collections) {
          final collectionName = collection['title']?.toString() ?? 'أحاديث';
          categorized[collectionName] = [];
          
          // Add collection info as the first item
          categorized[collectionName]!.add({
            'id': 'collection_${collectionName.hashCode}',
            'title': collectionName,
            'content': collection['description']?.toString() ?? 'مجموعة أحاديث من $collectionName',
            'reference': collectionName,
            'isHeader': true,
          });
          
          // Try to load hadiths for this collection
          try {
            final hadiths = await IslamwebHadithService
                .getHadithsFromCollection(collection['url'] ?? '')
                .timeout(const Duration(seconds: 10));
                
            if (hadiths.isNotEmpty) {
              categorized[collectionName]!.addAll(hadiths);
            }
          } catch (e) {
            print('Error loading hadiths for $collectionName: $e');
          }
        }
      } catch (e) {
        print('Error loading from Islamweb: $e');
      }
    }
    
    // If still no hadiths, try loading from local JSON
    if (categorized.isEmpty) {
      try {
        final hadiths = await fetchHadiths();
        for (var hadith in hadiths) {
          final category = hadith['category']?.toString() ?? 'أحاديث متنوعة';
          categorized.putIfAbsent(category, () => []);
          categorized[category]!.add({
            'id': hadith['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'title': hadith['title']?.toString() ?? 'حديث شريف',
            'content': hadith['content']?.toString() ?? hadith['text']?.toString() ?? '',
            'reference': hadith['reference']?.toString() ?? category,
            'audioUrl': hadith['audio']?.toString(),
          });
        }
      } catch (e) {
        print('Error loading local hadiths: $e');
      }
    }
      
    // Ensure we have at least some hadiths to display
    if (categorized.isEmpty) {
      categorized['أحاديث نبوية'] = getSampleHadiths();
    }

    return categorized;
  }
}
