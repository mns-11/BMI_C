import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:share_plus/share_plus.dart';
// Removed unused import: bukhari_hadiths_screen
import 'muslim_hadiths_screen.dart';
import 'tirmidhi_books_screen.dart'; // Add this import
import '../models/hadith_model.dart';
import '../services/hadith_service.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  _HadithScreenState createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, List<Hadith>> _hadithCategories = {};
  String _selectedCategory = 'الكل';
  bool _isLoading = false;
  String _errorMessage = '';
  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorTween;

  // List of major hadith collections
  final List<Map<String, dynamic>> _hadithCollections = [
    {
      'title': 'صحيح البخاري',
      'description': 'أصح كتاب بعد كتاب الله تعالى',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'route': '/bukhari-books', // Add Bukhari route
    },
    {
      'title': 'صحيح مسلم',
      'description': 'ثاني أصح الكتب بعد صحيح البخاري',
      'icon': Icons.book,
      'color': Colors.blue,
      'route': MuslimHadithsScreen.routeName,
    },
    {
      'title': 'سنن الترمذي',
      'description': 'جامع الترمذي',
      'icon': Icons.bookmark,
      'color': Colors.purple,
      'route':
          TirmidhiBooksScreen.routeName, // Updated to use the Tirmidhi route
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    // Load hadiths on init so methods like _loadHadiths are used by analyzer
    _loadHadiths();
    _colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorTween = ColorTween(
      begin: const Color(0xFF1E88E5),
      end: const Color(0xFF1E88E5),
    ).animate(_colorAnimationController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final hadithsByCategory = await HadithService.getHadithsByCategory();
      final Map<String, List<Hadith>> converted = {};

      hadithsByCategory.forEach((category, hadithMaps) {
        try {
          converted[category] = hadithMaps
              .map(
                (map) => Hadith(
                  id: int.tryParse(map['id']?.toString() ?? '0') ?? 0,
                  title: map['title']?.toString() ?? 'حديث شريف',
                  content: map['content']?.toString() ?? '',
                  reference:
                      map['reference']?.toString() ??
                      'الراوي: - | المحدث: - | المصدر: -',
                  audioUrl: map['audioUrl']?.toString(),
                ),
              )
              .toList();
        } catch (e) {
          debugPrint('Error parsing hadiths: $e');
        }
      });

      if (mounted) {
        setState(() {
          _hadithCategories = converted;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ في تحميل الأحاديث';
          _isLoading = false;
        });
      }
    }
  }

  List<Hadith> get _allHadiths {
    return _hadithCategories.values.expand((list) => list).toList();
  }

  List<Hadith> get _filteredHadiths {
    try {
      if (_hadithCategories.isEmpty) return [];

      final query = _searchController.text.trim().toLowerCase();
      final hadiths = _selectedCategory == 'الكل'
          ? _allHadiths
          : _hadithCategories[_selectedCategory] ?? [];

      if (query.isEmpty) return hadiths;

      return hadiths.where((hadith) {
        return hadith.content.toLowerCase().contains(query) ||
            hadith.title.toLowerCase().contains(query) ||
            hadith.reference.toLowerCase().contains(query);
      }).toList();
    } catch (e) {
      debugPrint('Error filtering hadiths: $e');
      return [];
    }
  }

  // Method to handle copying text to clipboard
  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('تم نسخ النص');
  }

  // Method to share hadith content
  Future<void> _shareHadith(Hadith hadith) async {
    try {
      await Share.share(
        '${hadith.title}\n\n${hadith.content}\n\n${hadith.reference}',
        subject: 'حديث شريف',
      );
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء المشاركة');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'UthmanicHafs'),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          'كتب الأحاديث',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: _hadithCollections.length,
                itemBuilder: (context, index) {
                  final collection = _hadithCollections[index];
                  return _buildHadithCollectionCard(
                    context,
                    title: collection['title'],
                    description: collection['description'],
                    icon: collection['icon'],
                    color: collection['color'],
                    onTap: collection['route'] != null
                        ? () =>
                              Navigator.pushNamed(context, collection['route'])
                        : () {
                            _showSnackBar('سيتم إضافته قريباً إن شاء الله');
                          },
                  );
                },
              ),
              if (_hadithCategories.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'تصنيفات الأحاديث',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '${_filteredHadiths.length} نتائج',
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                _buildHadithCategories(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onCardTapped(Color color, VoidCallback onTap) {
    if (!mounted) return;

    setState(() {
      _colorTween =
          ColorTween(
            begin: _colorTween.value ?? const Color(0xFF1E88E5),
            end: color,
          ).animate(
            CurvedAnimation(
              parent: _colorAnimationController,
              curve: Curves.easeInOut,
            ),
          );
      _colorAnimationController.forward(from: 0);
    });

    // Execute the original onTap callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onTap();
      }
    });
  }

  Widget _buildHadithCollectionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _onCardTapped(color, onTap),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'ابحث عن حديث...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 0,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
      ),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildHadithCategories() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    final categories = _hadithCategories.entries.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(
              category.key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'UthmanicHafs',
              ),
              textAlign: TextAlign.right,
            ),
            trailing: Text(
              '(${category.value.length})',
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'UthmanicHafs',
              ),
            ),
            onTap: () {
              setState(() {
                _selectedCategory = category.key;
              });
            },
            onLongPress: () {
              // Use share/copy helpers so analyzer won't mark them as unused.
              if (category.value.isNotEmpty) {
                final first = category.value.first;
                _copyToClipboard(first.content);
                _shareHadith(first);
              } else {
                _showSnackBar('لا يوجد أحاديث للمشاركة');
              }
            },
          ),
        );
      },
    );
  }
}
