import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

/// Audio service that handles Quran audio playback
/// Supports multiple reciters and handles audio session management
class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  int? _currentSurah;
  int? _currentVerse;

  /// Get the singleton instance
  factory AudioService() => _instance;

  /// Private constructor
  AudioService._internal() {
    _initAudioPlayer();
  }

  /// Initialize audio player with proper configuration
  Future<void> _initAudioPlayer() async {
    try {
      if (_isInitialized) return;
      
      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
        androidWillPauseWhenDucked: true,
      ));
      
      await session.setActive(true);
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ AudioService initialized successfully');
      }
    } catch (e, stackTrace) {
      _isInitialized = false;
      if (kDebugMode) {
        print('❌ Error initializing AudioService: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Play a complete surah
  Future<void> playSurah(int surahNumber) async {
    if (kDebugMode) {
      print('🎵 playSurah called for surah: $surahNumber');
    }
    
    try {
      if (!_isInitialized) {
        await _initAudioPlayer();
      }

      // If already playing this surah, just toggle play/pause
      if (_currentSurah == surahNumber && _audioPlayer.playing) {
        await _audioPlayer.pause();
        return;
      }

      _currentSurah = surahNumber;
      _currentVerse = null; // Reset current verse when playing full surah

      // Stop any currently playing audio
      await _audioPlayer.stop();
      
      // Format surah number with leading zeros
      final formattedSurah = surahNumber.toString().padLeft(3, '0');
      
      if (kDebugMode) {
        print('🎵 Attempting to play surah $surahNumber');
      }
      
      // List of potential audio sources to try (ordered by reliability)
      final urls = <String>[
        // Primary source - Mishary Alafasy
        'https://server8.mp3quran.net/afs/$formattedSurah.mp3',
        'https://cdn.islamic.network/quran/audio/64/ar.alafasy/$surahNumber.mp3',
        
        // Alternative sources
        'https://verses.quran.com/arabic/mishary_rashid_alafasy/$formattedSurah.mp3',
        'https://download.quranicaudio.com/quran/mishary_rashid_alafasy/murattal/$formattedSurah.mp3',
        
        // More alternatives
        'https://server13.mp3quran.net/mahermuaiqly/$formattedSurah.mp3',
        'https://server11.mp3quran.net/husr/$formattedSurah.mp3',
      ];
      
      if (kDebugMode) {
        print('🔄 Trying ${urls.length} audio sources...');
      }
      
      // Try each URL until one works
      for (final url in urls) {
        try {
          if (kDebugMode) {
            print('🔊 Trying: $url');
          }
          
          // Set the audio source
          await _audioPlayer.setUrl(url);
          
          // Start playback
          await _audioPlayer.play();
          
          // Wait a bit to see if it starts playing
          int retries = 0;
          bool isPlaying = false;
          
          // Check playback state with retries
          while (retries < 5 && !isPlaying) {
            await Future.delayed(const Duration(milliseconds: 300));
            isPlaying = _audioPlayer.playing;
            retries++;
            if (kDebugMode) {
              print('Playback check $retries/5 - Playing: $isPlaying');
            }
          }
          
          if (isPlaying) {
            if (kDebugMode) {
              print('✅ Successfully started playing from: $url');
            }
            return; // Successfully started playing
          }
          
          // If not playing, try the next URL
          await _audioPlayer.stop();
          
        } catch (e) {
          if (kDebugMode) {
            print('❌ Failed to play from $url: $e');
          }
          continue; // Try next URL
        }
      }
      
      throw Exception('Could not play audio from any source');
      
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error in playSurah: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Pause the currently playing audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      if (kDebugMode) {
        print('⏸️ Audio playback paused');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error pausing audio: $e');
      }
      rethrow;
    }
  }

  /// Stop the currently playing audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentSurah = null;
      _currentVerse = null;
      if (kDebugMode) {
        print('⏹️ Audio playback stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error stopping audio: $e');
      }
      rethrow;
    }
  }

  /// Seek to a specific position in the current audio
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      if (kDebugMode) {
        print('🔍 Seeking to: ${position.inSeconds}s');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error seeking audio: $e');
      }
      rethrow;
    }
  }

  // Getters for streams and state
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  
  // Current playback state
  int? get currentSurah => _currentSurah;
  int? get currentVerse => _currentVerse;
  bool get isPlaying => _audioPlayer.playing;
  Duration? get currentPosition => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      _isInitialized = false;
      if (kDebugMode) {
        print('♻️ AudioService disposed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error disposing AudioService: $e');
      }
      rethrow;
    }
  }
}
