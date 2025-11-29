import 'package:flutter/material.dart';
import '../models/quran/quran_surah_model.dart';
import '../services/hiquran_service.dart';
import 'quran_pdf_screen.dart'; // Import PDF screen instead
import '../theme/app_theme.dart';

// Helper function to remove diacritical marks from Arabic text
String _removeDiacritics(String text) {
  // Remove all Arabic diacritical marks (harakat)
  return text
      .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // Tanween, shadda, etc.
      .replaceAll(RegExp(r'[\u0670]'), '') // Super script alif
      .replaceAll(RegExp(r'[\u0640]'), ''); // Tatweel
}

class QuranSurahsScreen extends StatefulWidget {
  const QuranSurahsScreen({super.key});

  @override
  State<QuranSurahsScreen> createState() => _QuranSurahsScreenState();
}

class _QuranSurahsScreenState extends State<QuranSurahsScreen> {
  // Removed unused future field
  final TextEditingController _searchController = TextEditingController();
  List<QuranSurahModel> _allSurahs = [];
  List<QuranSurahModel> _filteredSurahs = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    _filterSurahs(query);
  }

  void _filterSurahs(String query) {
    // Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = List.from(_allSurahs);
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          // Search in both original and diacritics-free versions
          final searchQuery = query;
          final surahNameWithoutDiacritics = _removeDiacritics(
            surah.name,
          ).toLowerCase();
          return surah.name.toLowerCase().contains(searchQuery) ||
              surahNameWithoutDiacritics.contains(searchQuery) ||
              surah.englishName.toLowerCase().contains(searchQuery) ||
              surah.number.toString() == query;
        }).toList();
      }
    });
  }

  Future<void> _loadSurahs() async {
    // Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final surahs = await HiQuranService.fetchSurahs();
      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = List.from(surahs);
        _isLoading = false;
      });
    } catch (e) {
      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _errorMessage = 'حدث خطأ في تحميل السور. يرجى المحاولة مرة أخرى.';
        _isLoading = false;
      });
      print('Error loading surahs: $e');
    }
  }

  void _navigateToSurahPdf(QuranSurahModel surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuranPdfScreen(initialPage: surah.pageStart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.appBarGradient),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _buildSurahsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahsList() {
    if (_filteredSurahs.isEmpty) {
      return const Center(child: Text('لا توجد نتائج'));
    }

    return ListView.builder(
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Text(surah.number.toString())),
            title: Text(
              _removeDiacritics(surah.name),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${surah.numberOfAyahs} آيات',
              textAlign: TextAlign.right,
            ),
            trailing: const SizedBox.shrink(),
            onTap: () =>
                _navigateToSurahPdf(surah), // Changed to PDF navigation
          ),
        );
      },
    );
  }
}
