import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  _HadithScreenState createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';

  final List<Map<String, dynamic>> _hadithCategories = [
    {
      'title': 'أحاديث الصلاة',
      'icon': Icons.mosque,
      'color': Colors.green,
      'hadiths': [
        {
          'title': 'أول ما يحاسب به العبد',
          'arabic':
              'إِنَّ أَوَّلَ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ مِنْ عَمَلِهِ صَلَاتُهُ، فَإِنْ صَلَحَتْ فَقَدْ أَفْلَحَ وَأَنْجَحَ، وَإِنْ فَسَدَتْ فَقَدْ خَابَ وَخَسِرَ',
          'translation': 'رواه الترمذي',
          'grade': 'صحيح',
          'explanation':
              'يؤكد الحديث على عظم شأن الصلاة وأنها أول ما يُسأل عنه العبد يوم القيامة',
        },
        {
          'title': 'خمس صلوات',
          'arabic':
              'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَصَوْمِ رَمَضَانَ، وَحَجِّ الْبَيْتِ',
          'translation': 'متفق عليه',
          'grade': 'صحيح',
          'explanation':
              'يبين الحديث أركان الإسلام الخمسة التي بُني عليها الإسلام',
        },
      ],
    },
    {
      'title': 'أحاديث الصيام',
      'icon': Icons.nightlight_round,
      'color': Colors.blue,
      'hadiths': [
        {
          'title': 'من صام رمضان إيماناً واحتساباً',
          'arabic':
              'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا، غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
          'translation': 'متفق عليه',
          'grade': 'صحيح',
          'explanation':
              'يبشر النبي ﷺ الصائمين في رمضان إيماناً واحتساباً بمغفرة الذنوب',
        },
      ],
    },
    {
      'title': 'أحاديث الأخلاق',
      'icon': Icons.self_improvement,
      'color': Colors.purple,
      'hadiths': [
        {
          'title': 'أكمل المؤمنين إيماناً',
          'arabic': 'أَكْمَلُ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا',
          'translation': 'رواه الترمذي',
          'grade': 'صحيح',
          'explanation': 'يؤكد الحديث على أهمية حسن الخلق في كمال الإيمان',
        },
        {
          'title': 'البر حسن الخلق',
          'arabic':
              'الْبِرُّ حُسْنُ الْخُلُقِ، وَالْإِثْمُ مَا حَاكَ فِي صَدْرِكَ وَكَرِهْتَ أَنْ يَطَّلِعَ عَلَيْهِ النَّاسُ',
          'translation': 'رواه مسلم',
          'grade': 'صحيح',
          'explanation': 'يحدد النبي ﷺ معيار البر والإثم',
        },
      ],
    },
    {
      'title': 'أحاديث الدعاء',
      'icon': Icons.handshake,
      'color': Colors.orange,
      'hadiths': [
        {
          'title': 'دعاء الاستيقاظ',
          'arabic':
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          'translation': 'رواه البخاري',
          'grade': 'صحيح',
          'explanation': 'من أذكار الصباح المأثورة',
        },
      ],
    },
  ];

  // Get all hadiths from all categories
  List<Map<String, dynamic>> get _allHadiths {
    List<Map<String, dynamic>> allHadiths = [];
    for (var category in _hadithCategories) {
      for (var hadith in category['hadiths']) {
        allHadiths.add({
          ...hadith,
          'category': category['title'],
          'icon': category['icon'],
          'color': category['color'],
        });
      }
    }
    return allHadiths;
  }

  // Get filtered hadiths based on search query and selected category
  List<Map<String, dynamic>> get _filteredHadiths {
    final query = _searchController.text.toLowerCase();

    return _allHadiths.where((hadith) {
      final matchesSearch =
          query.isEmpty ||
          hadith['title'].toLowerCase().contains(query) ||
          hadith['arabic'].contains(query) ||
          hadith['translation'].toLowerCase().contains(query) ||
          hadith['explanation'].toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'الكل' ||
          hadith['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأحاديث النبوية',
          style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB2DFDB), Color(0xFFD1C4E9)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن حديث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Categories
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('الكل'),
                ..._hadithCategories.map(
                  (category) => _buildCategoryChip(category['title']),
                ),
              ],
            ),
          ),

          // Hadiths count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filteredHadiths.length} حديث',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Text('إلغاء البحث'),
                  ),
              ],
            ),
          ),

          // Hadiths list
          Expanded(
            child: _filteredHadiths.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد نتائج للبحث',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _filteredHadiths.length,
                    itemBuilder: (context, index) {
                      final hadith = _filteredHadiths[index];
                      return _buildHadithCard(hadith, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    final isSelected = _selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? title : 'الكل';
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.green[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.green[800] : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.green[400]! : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(Map<String, dynamic> hadith, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category label
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: hadith['color'].withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Icon(hadith['icon'], size: 16, color: hadith['color']),
                  const SizedBox(width: 8),
                  Text(
                    hadith['category'],
                    style: TextStyle(
                      color: hadith['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: hadith['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Hadith content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hadith title
                  Text(
                    hadith['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),

                  const SizedBox(height: 16),

                  // Arabic text
                  Text(
                    hadith['arabic'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'UthmanicHafs',
                      height: 1.8,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 16),

                  // Translation and reference
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Translation
                        Text(
                          hadith['explanation'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),

                        const SizedBox(height: 8),

                        // Reference and grade
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green[100]!),
                              ),
                              child: Text(
                                hadith['grade'],
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hadith['translation'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Share button
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'مشاركة',
                        color: Colors.blue,
                        onTap: () => _shareHadith(hadith),
                      ),

                      // Copy button
                      _buildActionButton(
                        icon: Icons.copy,
                        label: 'نسخ',
                        color: Colors.orange,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text:
                                  '${hadith['title']}\n\n${hadith['arabic']}\n\n${hadith['translation']}\n\n${hadith['explanation']}',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم نسخ الحديث بنجاح'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),

                      // Bookmark button
                      _buildActionButton(
                        icon: Icons.bookmark_border,
                        label: 'حفظ',
                        color: Colors.purple,
                        onTap: () {
                          // TODO: Implement bookmark functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت إضافة الحديث إلى المفضلة'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _shareHadith(Map<String, dynamic> hadith) {
    final text =
        '${hadith['title']}\n\n${hadith['arabic']}\n\n${hadith['translation']}\n\n${hadith['explanation']}';
    Share.share(text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
