import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/youtube_video_model.dart';

class YouTubeService {
  static const String _apiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String _baseUrl = 'www.googleapis.com';
  static const int _maxResults = 10;

  static Future<List<YouTubeVideoModel>> searchVideos(String query) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/youtube/v3/search',
        {
          'part': 'snippet',
          'q': query,
          'type': 'video',
          'maxResults': _maxResults.toString(),
          'key': _apiKey,
          'videoEmbeddable': 'true',
        },
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videos = data['items'] ?? [];
        
        // Get video durations
        final videoIds = videos.map((v) => v['id']['videoId']).join(',');
        final durationResponse = await http.get(
          Uri.https(
            _baseUrl,
            '/youtube/v3/videos',
            {
              'part': 'contentDetails',
              'id': videoIds,
              'key': _apiKey,
            },
          ),
        );

        if (durationResponse.statusCode == 200) {
          final durationData = json.decode(durationResponse.body);
          final durationMap = {
            for (var item in durationData['items'])
              item['id']: item['contentDetails']['duration']
          };

          return videos.map<YouTubeVideoModel>((video) {
            return YouTubeVideoModel.fromJson({
              ...video,
              'contentDetails': {
                'duration': durationMap[video['id']['videoId']] ?? 'PT0S',
              },
            });
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching YouTube videos: $e');
      return [];
    }
  }
}
