import 'package:flutter/material.dart';
import '../models/quran/quran_surah_model.dart';
import '../services/hiquran_service.dart';
import '../services/quran_local_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'mushaf_screen.dart'; // Add this import for MushafScreen

class SurahDetailScreen extends StatefulWidget {
  final QuranSurahModel surah;

  const SurahDetailScreen({Key? key, required this.surah}) : super(key: key);

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PageController _pageController = PageController();

  bool _isLoading = true;
  bool _isPlaying = false;
  String? _errorMessage;
  List<String> _pages = [];
  int _currentPage = 0;
  late QuranSurahModel
  _currentSurah; // Local variable to hold the surah with audio
  String? _bismillahText; // Store the Bismillah text separately

  // Timestamp list
  List<Map<String, dynamic>> _timestamps = [];
  int _currentAyahIndex = 0;

  // Text scaling factor for zoom functionality
  double _textScaleFactor = 1.0;
  static const double _minScaleFactor = 0.5;
  static const double _maxScaleFactor = 2.0;
  static const double _scaleStep = 0.1;

  @override
  void initState() {
    super.initState();
    _currentSurah = widget.surah; // Initialize with widget surah
    _loadSurah();
    _loadPagesAndTimestamps();
    _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));

    // Add listener for audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      if (state.processingState == ProcessingState.completed) {
        setState(() => _isPlaying = false);
      }
    });

    // Add listener for position changes to update current page
    _audioPlayer.currentIndexStream.listen((index) {
      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      if (index != null) {
        // Calculate which page this ayah belongs to
        // We need to account for the starting page offset
        final int startAyahIndex = _currentPage * 15;
        final int actualAyahIndex = startAyahIndex + index;
        int page = (actualAyahIndex / 15).floor();

        if (_currentPage != page && page < _pages.length) {
          setState(() => _currentPage = page);
          // Animate to the page
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSurah() async {
    try {
      // Try to load from local service first
      final surah = await QuranLocalService.loadSurahWithAyahsFromLocal(
        _currentSurah.number,
      );

      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _currentSurah = surah;
      });
    } catch (localError) {
      // If local loading fails, fall back to API
      try {
        final surah = await HiQuranService.fetchSurahWithAyahs(
          _currentSurah.number,
        );

        // Check if the widget is still mounted before calling setState
        if (!mounted) return;

        setState(() {
          _currentSurah = surah;
        });
      } catch (apiError) {
        // Check if the widget is still mounted before calling setState
        if (!mounted) return;

        setState(() {
          _errorMessage = 'فشل تحميل السورة. يرجى المحاولة مرة أخرى.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPagesAndTimestamps() async {
    // Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to load from local service first
      final surah = await QuranLocalService.loadSurahWithAyahsFromLocal(
        _currentSurah.number,
      );

      // Load timestamps from EveryAyah (this still requires internet)
      final response = await http.get(
        Uri.parse(
          'https://everyayah.com/data/Muaiqly_Murattal/metadata/${_currentSurah.number.toString().padLeft(3, '0')}.json',
        ),
      );

      // Check if the widget is still mounted before continuing
      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _timestamps = List<Map<String, dynamic>>.from(jsonData['verses']);
      }

      // Extract Bismillah from the first ayah (if it exists and it's not Surah 9)
      _bismillahText = null;
      if (surah.number != 9 && surah.ayahs.isNotEmpty) {
        _bismillahText = extractBismillah(surah.ayahs.first.text);
      }

      // Build pages (15 ayahs each)
      final ayahsPerPage = 15;
      final totalPages = (surah.ayahs.length / ayahsPerPage).ceil();

      _pages = List.generate(totalPages, (pageIndex) {
        final startIndex = pageIndex * ayahsPerPage;
        final endIndex = (startIndex + ayahsPerPage > surah.ayahs.length)
            ? surah.ayahs.length
            : startIndex + ayahsPerPage;

        return surah.ayahs
            .sublist(startIndex, endIndex)
            .map((ayah) {
              // ALWAYS remove Bismillah from Ayah 1 of ANY surah
              String ayahText = removeBasmala(ayah.text);

              return ayahText;
            })
            .join(' ۝ ');
      });

      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() => _isLoading = false);
    } catch (localError) {
      // If local loading fails, fall back to API
      try {
        final surah = await HiQuranService.fetchSurahWithAyahs(
          _currentSurah.number,
        );

        // Load timestamps from EveryAyah
        final response = await http.get(
          Uri.parse(
            'https://everyayah.com/data/Muaiqly_Murattal/metadata/${_currentSurah.number.toString().padLeft(3, '0')}.json',
          ),
        );

        // Check if the widget is still mounted before continuing
        if (!mounted) return;

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          _timestamps = List<Map<String, dynamic>>.from(jsonData['verses']);
        }

        // Extract Bismillah from the first ayah (if it exists and it's not Surah 9)
        _bismillahText = null;
        if (surah.number != 9 && surah.ayahs.isNotEmpty) {
          _bismillahText = extractBismillah(surah.ayahs.first.text);
        }

        // Build pages (15 ayahs each)
        final ayahsPerPage = 15;
        final totalPages = (surah.ayahs.length / ayahsPerPage).ceil();

        _pages = List.generate(totalPages, (pageIndex) {
          final startIndex = pageIndex * ayahsPerPage;
          final endIndex = (startIndex + ayahsPerPage > surah.ayahs.length)
              ? surah.ayahs.length
              : startIndex + ayahsPerPage;

          return surah.ayahs
              .sublist(startIndex, endIndex)
              .map((ayah) {
                // ALWAYS remove Bismillah from Ayah 1 of ANY surah
                String ayahText = removeBasmala(ayah.text);

                return ayahText;
              })
              .join(' ۝ ');
        });

        // Check if the widget is still mounted before calling setState
        if (!mounted) return;

        setState(() => _isLoading = false);
      } catch (apiError) {
        // Check if the widget is still mounted before calling setState
        if (!mounted) return;

        setState(() {
          _errorMessage = 'فشل تحميل السورة. يرجى المحاولة مرة أخرى.';
          _isLoading = false;
        });
      }
    }
  }

  // ignore: unused_element
  void _updateCurrentAyah(Duration position) {
    // Check if the widget is still mounted
    if (!mounted) return;

    if (_timestamps.isEmpty) return;

    for (int i = 0; i < _timestamps.length; i++) {
      final start = Duration(
        milliseconds: (_timestamps[i]['timestamp_from'] * 1000).round(),
      );
      final end = Duration(
        milliseconds: (_timestamps[i]['timestamp_to'] * 1000).round(),
      );

      if (position >= start && position <= end) {
        if (_currentAyahIndex != i) {
          setState(() => _currentAyahIndex = i);

          int page = (i / 15).floor();
          if (_currentPage != page) {
            _pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    }
  }

  String extractBismillah(String ayahText) {
    // Check if the ayah starts with Bismillah
    if (ayahText.startsWith('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ')) {
      return 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
    }
    // Check if it starts with a variation
    else if (ayahText.startsWith('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
      return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
    }
    return '';
  }

  String removeBasmala(String ayahText) {
    // Remove Bismillah if it exists at the beginning
    if (ayahText.startsWith('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ')) {
      return ayahText
          .substring('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'.length)
          .trim();
    } else if (ayahText.startsWith('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
      return ayahText
          .substring('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'.length)
          .trim();
    }
    return ayahText;
  }

  // Methods for text zoom functionality
  void _zoomIn() {
    setState(() {
      _textScaleFactor = math.min(
        _textScaleFactor + _scaleStep,
        _maxScaleFactor,
      );
    });
  }

  void _zoomOut() {
    setState(() {
      _textScaleFactor = math.max(
        _textScaleFactor - _scaleStep,
        _minScaleFactor,
      );
    });
  }

  void _resetZoom() {
    setState(() {
      _textScaleFactor = 1.0;
    });
  }

  Widget _buildVerseText(String pageText, {required int startVerse}) {
    final ayahs = pageText.split(' ۝ ');
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      textDirection: TextDirection.rtl,
      children: List.generate(ayahs.length, (index) {
        final ayahNumber = startVerse + index;
        final isHighlighted = ayahNumber - 1 == _currentAyahIndex;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              // Ayah number in a circle
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _toArabicNumber(ayahNumber),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Ayah text
              Flexible(
                child: Text(
                  ayahs[index],
                  textAlign: TextAlign.right,
                  textScaleFactor: _textScaleFactor,
                  style: TextStyle(
                    fontFamily: 'KFGQPC',
                    fontSize: 20,
                    color: isHighlighted ? Colors.blue[800] : Colors.black87,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _toArabicNumber(int number) {
    final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicDigits[int.parse(digit)])
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentSurah.name.startsWith('سورة')
              ? _currentSurah.name
              : ' ${_currentSurah.name}',
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1967D2), Color(0xFF2196F3)], // Blue gradient
            ),
          ),
        ),
        actions: [
          // Mushaf button to navigate to the Mushaf screen
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MushafScreen(
                    initialPage: widget.surah.pageStart, // رقم أول صفحة للسورة
                  ),
                ),
              );
            },
          ),
          // Zoom controls in AppBar - zoom out and zoom in buttons side by side
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 20),
                        // Display Bismillah from the first ayah under progress bar in blue color (except for Surah 9)
                        if (_bismillahText != null)
                          Center(
                            child: Text(
                              _bismillahText!,
                              textAlign: TextAlign.center,
                              textScaleFactor: _textScaleFactor,
                              style: TextStyle(
                                fontFamily: 'KFGQPC',
                                fontSize: 28,
                                color: Color(0xFF1967D2), // Blue color
                              ),
                            ),
                          ),
                      ],
                    )
                  : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : Column(
                      children: [
                        // Display Bismillah from the first ayah at the top center (except for Surah 9)
                        if (_bismillahText != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _bismillahText!,
                              textAlign: TextAlign.center,
                              textScaleFactor: _textScaleFactor,
                              style: TextStyle(
                                fontFamily: 'KFGQPC',
                                fontSize: 28,
                                color: Color(0xFF1967D2), // Blue color
                              ),
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                40,
                              ), // Add extra bottom padding for page number
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _buildVerseText(
                                _pages.join(
                                  ' ۝ ',
                                ), // Join all pages to display all ayahs together
                                startVerse: 1,
                              ),
                            ),
                          ),
                        ),
                        // Page number at bottom left
                        Container(
                          padding: const EdgeInsets.only(left: 24, bottom: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_toArabicNumber(1)} من ${_toArabicNumber(1)}',
                            textScaleFactor: _textScaleFactor,
                            style: const TextStyle(
                              color: Color(0xFF1967D2), // Blue color
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: () async {
          try {
            if (_isPlaying) {
              await _audioPlayer.pause();
              setState(() => _isPlaying = false);
            } else {
              // Play from current page onwards
              // Calculate start ayah based on current page
              final int startAyahIndex = _currentPage * 15;

              // Get ayahs from current page onwards that have audio URLs
              final List<QuranAyah> remainingAyahs = _currentSurah.ayahs
                  .sublist(startAyahIndex)
                  .where((ayah) => ayah.audioUrl.isNotEmpty)
                  .toList();

              if (remainingAyahs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لا توجد ملفات صوتية متاحة لبقية الصفحة'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Create audio source for remaining ayahs
              final List<AudioSource> audioSources = remainingAyahs
                  .map((ayah) => AudioSource.uri(Uri.parse(ayah.audioUrl)))
                  .toList();

              final ConcatenatingAudioSource audioSource =
                  ConcatenatingAudioSource(children: audioSources);

              await _audioPlayer.setAudioSource(audioSource);
              setState(() => _isPlaying = true);
              await _audioPlayer.play();
            }
          } catch (e) {
            print('Error playing audio: $e');
            setState(() => _isPlaying = false);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'حدث خطأ في تشغيل الصوت. تأكد من الاتصال بالإنترنت',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
