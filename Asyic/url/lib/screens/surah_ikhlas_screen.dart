import 'package:flutter/material.dart';
import '../models/quran/quran_surah_model.dart';
import '../services/hiquran_service.dart';

class SurahIkhlasScreen extends StatefulWidget {
  const SurahIkhlasScreen({super.key});

  @override
  State<SurahIkhlasScreen> createState() => _SurahIkhlasScreenState();
}

class _SurahIkhlasScreenState extends State<SurahIkhlasScreen> {
  QuranSurahModel? _surah;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSurahIkhlas();
  }

  Future<void> _loadSurahIkhlas() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Surah Al-Ikhlas is number 112
      final surah = await HiQuranService.fetchSurahWithAyahs(112);

      setState(() {
        _surah = surah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل سورة الإخلاص: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سورة الإخلاص',
          style: TextStyle(
            fontFamily: 'KFGQPC',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B5E20)),
                ),
              )
            : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadSurahIkhlas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              )
            : _buildSurahContent(),
      ),
    );
  }

  Widget _buildSurahContent() {
    if (_surah == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Surah header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'سورة الإخلاص',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'KFGQPC',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'السورة رقم ${_surah!.number}',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  '${_surah!.numberOfAyahs} آيات',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  _surah!.revelationType == 'meccan' ? 'مكية' : 'مدنية',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bismillah (separate for all surahs except At-Tawbah)
          if (_surah!.number != 9)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'KFGQPC',
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Verses
          ...List.generate(_surah!.verses.length, (index) {
            final verse = _surah!.verses[index];
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Verse number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            verse.numberInSurah.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Verse text
                  Text(
                    verse.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'KFGQPC',
                      color: Colors.black87,
                      height: 2.0,
                    ),
                    textAlign: TextAlign.right,
                  ),

                  if (verse.translation.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        verse.translation,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          // Footer
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'صدق الله العظيم',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'KFGQPC',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
