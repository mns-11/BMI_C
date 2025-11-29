import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;
  final String? alternativeAudioUrl;
  final String? youtubeUrl;
  final String title;

  const AudioPlayerScreen({
    super.key,
    required this.audioUrl,
    this.alternativeAudioUrl,
    this.youtubeUrl,
    required this.title,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _maxDuration = 100.0; // Will be updated when audio loads

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Album Art/Placeholder
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Slider(
                      value: _currentPosition,
                      min: 0,
                      max: _maxDuration,
                      onChanged: (value) {
                        setState(() {
                          _currentPosition = value;
                        });
                        // TODO: Seek to position in audio
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_currentPosition)),
                          Text(_formatDuration(_maxDuration)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Controls
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous Button
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 40),
                    onPressed: () {
                      // TODO: Previous track logic
                    },
                  ),
                  const SizedBox(width: 16),
                  
                  // Play/Pause Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 48,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        // TODO: Play/Pause logic
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Next Button
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 40),
                    onPressed: () {
                      // TODO: Next track logic
                    },
                  ),
                ],
              ),
              
              // Additional Options
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Repeat Button
                  IconButton(
                    icon: const Icon(Icons.repeat, size: 28),
                    onPressed: () {
                      // TODO: Repeat logic
                    },
                  ),
                  
                  // Speed Button
                  TextButton.icon(
                    icon: const Icon(Icons.speed),
                    label: const Text('1.0x'),
                    onPressed: () {
                      // TODO: Change playback speed
                    },
                  ),
                  
                  // Share Button
                  IconButton(
                    icon: const Icon(Icons.share, size: 28),
                    onPressed: () {
                      // TODO: Share functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final remainingSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$remainingSeconds';
  }
  
  @override
  void dispose() {
    // TODO: Clean up audio resources
    super.dispose();
  }
}
