import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String surahName;
  final String reciterName;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.surahName,
    required this.reciterName,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _isLoading = true; // Start with loading state

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        _isLoading = state.processingState == ProcessingState.loading ||
                     state.processingState == ProcessingState.buffering;
      });
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
        if (duration != null && duration.inSeconds > 0) {
          _isLoading = false; // Stop loading when duration is available
        }
      });
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    // Set audio source
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // Check if URL is a YouTube search URL
      if (widget.audioUrl.contains('youtube.com')) {
        debugPrint('YouTube search URL detected: ${widget.audioUrl}');
        await _handleYouTubeUrl();
      } else {
        // Try to play direct audio URL
        debugPrint('Attempting to play direct audio: ${widget.audioUrl}');
        await _audioPlayer.setUrl(widget.audioUrl);
        _showErrorSnackBar('جاري تحميل التلاوة...');
      }
    } catch (e) {
      debugPrint('Error loading primary audio: $e');
      if (mounted) {
        _showErrorSnackBar('تعذر تشغيل الصوت الرئيسي، جاري تجربة المصدر البديل...');
        // Try alternative audio source
        await _tryAlternativeAudio();
      }
    }
  }

  Future<void> _tryAlternativeAudio() async {
    try {
      // This would need access to the alternative URL from the SurahAudio model
      // For now, just fallback to YouTube
      await _handleYouTubeUrl();
    } catch (e) {
      debugPrint('Error loading alternative audio: $e');
      if (mounted) {
        _showErrorSnackBar('تعذر تشغيل الصوت، جاري فتح يوتيوب...');
        await _handleYouTubeUrl();
      }
    }
  }

  Future<void> _handleYouTubeUrl() async {
    try {
      // For YouTube URLs, open in browser using url_launcher
      final Uri url = Uri.parse(widget.audioUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
        _showErrorSnackBar('تم فتح يوتيوب للبحث عن التلاوة');
      } else {
        _showErrorSnackBar('تعذر فتح الرابط');
      }
    } catch (e) {
      debugPrint('Error opening YouTube URL: $e');
      if (mounted) {
        _showErrorSnackBar('تعذر فتح يوتيوب');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEFEFE),
            Color(0xFFF8F8F8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD5580F).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD5580F).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with reciter and surah info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5580F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.headphones,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.surahName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'Amiri',
                      ),
                    ),
                    Text(
                      'القارئ: ${widget.reciterName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar and controls - always show when audio URL is available
          if (widget.audioUrl.isNotEmpty)
            Column(
              children: [
                // Show message about audio type
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: widget.audioUrl.contains('youtube.com')
                        ? Colors.amber.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.audioUrl.contains('youtube.com')
                          ? Colors.amber.withValues(alpha: 0.3)
                          : Colors.green.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.audioUrl.contains('youtube.com')
                            ? Icons.info_outline
                            : Icons.headphones,
                        size: 16,
                        color: widget.audioUrl.contains('youtube.com')
                            ? Colors.amber[700]
                            : Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.audioUrl.contains('youtube.com')
                              ? 'سيتم البحث في يوتيوب عن تلاوة ${widget.reciterName} لـ ${widget.surahName}'
                              : 'جاري تشغيل التلاوة مباشرة...',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.audioUrl.contains('youtube.com')
                                ? Colors.amber[700]
                                : Colors.green[700],
                            fontFamily: 'Roboto',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress bar - show when duration is available
                if (_duration.inSeconds > 0)
                  Column(
                    children: [
                      Slider(
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        min: 0,
                        activeColor: const Color(0xFFD5580F),
                        inactiveColor: Colors.grey[300],
                        onChanged: (value) async {
                          await _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),

          const SizedBox(height: 12),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // YouTube button (when URL is YouTube search)
              if (widget.audioUrl.contains('youtube.com'))
                ElevatedButton.icon(
                  onPressed: _handleYouTubeUrl,
                  icon: const Icon(Icons.play_circle_filled, size: 20),
                  label: const Text('افتح يوتيوب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              else ...[
                // Direct audio controls
                IconButton(
                  onPressed: _isLoading ? null : _stop,
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.stop,
                      color: _isLoading ? Colors.grey : Colors.red,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Play/Pause button
                ElevatedButton(
                  onPressed: _isLoading ? null : _playPause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5580F),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 32,
                        ),
                ),

                const SizedBox(width: 16),

                // Loading indicator when playing
                if (_isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD5580F)),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
