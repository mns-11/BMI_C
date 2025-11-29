import 'dart:convert';
import 'package:http/http.dart' as http;

class SunnahHadithService {
  static const String _baseUrl = 'https://api.sunnah.com/v1';
  // You should replace this with your own API key from sunnah.com
  static const String _apiKey = 'YOUR_SUNNAH_COM_API_KEY';

  // Get all available collections
  static Future<List<Map<String, dynamic>>> getCollections() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/collections'),
        headers: {'X-API-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (e) {
      print('Error getting collections: $e');
      return [];
    }
  }

  // Get books in a specific collection
  static Future<List<Map<String, dynamic>>> getBooks(String collectionName) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/collections/$collectionName/books'),
        headers: {'X-API-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error getting books: $e');
      return [];
    }
  }

  // Get hadiths from a specific book
  static Future<List<Map<String, dynamic>>> getHadiths(
      String collectionName, String bookNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/collections/$collectionName/books/$bookNumber/hadiths'),
        headers: {'X-API-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load hadiths');
      }
    } catch (e) {
      print('Error getting hadiths: $e');
      return [];
    }
  }

  // Search hadiths by text
  static Future<List<Map<String, dynamic>>> searchHadiths(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.sunnah.com/v2/search?query=$query&page=1&limit=20'),
        headers: {'X-API-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to search hadiths');
      }
    } catch (e) {
      print('Error searching hadiths: $e');
      return [];
    }
  }

  // Get a specific hadith by ID
  static Future<Map<String, dynamic>?> getHadithById(
      String collectionName, String hadithNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/collections/$collectionName/hadiths/$hadithNumber'),
        headers: {'X-API-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load hadith');
      }
    } catch (e) {
      print('Error getting hadith: $e');
      return null;
    }
  }
}
