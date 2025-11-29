import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/quran/reciter_model.dart';
import '../services/youtube_service.dart';
import '../models/youtube_video_model.dart';

class RecitersYouTubeScreen extends StatefulWidget {
  const RecitersYouTubeScreen({super.key});

  @override
  State<RecitersYouTubeScreen> createState() => _RecitersYouTubeScreenState();
}

class _RecitersYouTubeScreenState extends State<RecitersYouTubeScreen> {
  final List<Reciter> _reciters = quranReciters;
  final Map<String, List<YouTubeVideoModel>> _videos = {};
  bool _isLoading = false;

  Future<void> _loadVideos(Reciter reciter) async {
    if (_videos.containsKey(reciter.id)) return;

    setState(() => _isLoading = true);
    try {
      final videos = await YouTubeService.searchVideos(
          '${reciter.name} سورة');
      setState(() {
        _videos[reciter.id] = videos;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showVideoPlayer(YouTubeVideoModel video) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
        'https://www.youtube.com/embed/${video.videoId}?autoplay=1',
      ));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                video.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: WebViewWidget(controller: controller),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القراء'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reciters.length,
              itemBuilder: (context, index) {
                final reciter = _reciters[index];
                final videos = _videos[reciter.id] ?? [];
                
                return ExpansionTile(
                  title: Text(reciter.name),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(reciter.imageUrl),
                  ),
                  onExpansionChanged: (expanded) {
                    if (expanded) _loadVideos(reciter);
                  },
                  children: [
                    if (videos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('جاري التحميل...')),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return ListTile(
                            leading: Image.network(
                              video.thumbnailUrl,
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${video.duration.inMinutes}:${(video.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            ),
                            onTap: () => _showVideoPlayer(video),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
    );
  }
}
