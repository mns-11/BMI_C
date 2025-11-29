import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/reciter.dart';
import '../services/audio_service.dart';

class SurahListScreen extends StatefulWidget {
  final Reciter reciter;

  const SurahListScreen({super.key, required this.reciter});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  int? _currentPlayingSurah;
  Duration _position = Duration.zero;
  Duration? _duration;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _currentPlayingSurah = _audioService.currentSurah;
        });
      }
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      if (mounted) setState(() => _position = position);
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
  }

  Future<void> _togglePlayPause(int surahNumber) async {
    try {
      if (_isPlaying && _currentPlayingSurah == surahNumber) {
        await _audioService.pause();
      } else {
        await _audioService.playSurah(surahNumber);
      }
      setState(() {
        _isPlaying = _audioService.isPlaying;
        _currentPlayingSurah = _audioService.currentSurah;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciter.name),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.reciter.surahs.length,
        itemBuilder: (context, index) {
          final surah = widget.reciter.surahs[index];
          final surahNumber = index + 1; // Assuming surahs are in order
          final isCurrentSurah = _currentPlayingSurah == surahNumber;
          
          return Column(
            children: [
              ListTile(
                leading: Image.network(
                  surah.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book),
                ),
                title: Text(
                  surah.title,
                  style: TextStyle(
                    fontWeight: isCurrentSurah ? FontWeight.bold : FontWeight.normal,
                    color: isCurrentSurah ? Theme.of(context).primaryColor : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isCurrentSurah && _isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _togglePlayPause(surahNumber),
                ),
                onTap: () {
                  _togglePlayPause(surahNumber);
                },
              ),
              if (isCurrentSurah && _duration != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    children: [
                      Slider(
                        value: _position.inMilliseconds.toDouble(),
                        min: 0,
                        max: _duration!.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _audioService.seek(Duration(milliseconds: value.toInt()));
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            Text(
                              _formatDuration(_duration! - _position),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
