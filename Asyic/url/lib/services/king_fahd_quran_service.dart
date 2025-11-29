import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class KingFahdQuranService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _edition = 'quran-uthmani';
  
  // Cache for surahs list
  static List<Map<String, dynamic>>? _cachedSurahs;
  
  /// Get list of all surahs
  static Future<List<Map<String, dynamic>>> getAllSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;
    
    try {
      final response = await http.get(Uri.parse('$_baseUrl/surah'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _cachedSurahs = List<Map<String, dynamic>>.from(data['data']);
        return _cachedSurahs!;
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting surahs: $e');
      rethrow;
    }
  }
  
  /// Get complete surah by number
  static Future<Map<String, dynamic>> getSurah(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/editions/$_edition')
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]; // Return the Uthmani text (first edition)
      } else {
        throw Exception('Failed to load surah $surahNumber: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting surah $surahNumber: $e');
      rethrow;
    }
  }
  
  /// Get specific ayah by surah and ayah number
  static Future<Map<String, dynamic>> getAyah(int surahNumber, int ayahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ayah/$surahNumber:$ayahNumber/editions/$_edition')
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]; // Return the Uthmani text (first edition)
      } else {
        throw Exception('Failed to load ayah $surahNumber:$ayahNumber: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting ayah $surahNumber:$ayahNumber: $e');
      rethrow;
    }
  }
}
