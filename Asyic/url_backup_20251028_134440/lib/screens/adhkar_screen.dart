import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  int _currentIndex = 0;
  int? _selectedItemIndex;
  final List<Map<String, dynamic>> _adhkar = [
    // أذكار الصباح
    {
      'title': 'أذكار الصباح',
      'subtitle': 'من أذكار الصباح المأثورة',
      'items': [
        {
          'text': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'repeat': 1,
          'category': 'حفظ وأمان',
        },
        {
          'text': 'اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ.',
          'repeat': 4,
          'category': 'شهادة التوحيد',
        },
        {
          'text': 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          'repeat': 1,
          'category': 'حمد وشكر',
        },
        {
          'text': 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
          'repeat': 7,
          'category': 'التوكل على الله',
        },
        {
          'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ، وَهُوَ السَّمِيعُ الْبَصِيرُ.',
          'repeat': 3,
          'category': 'الحفظ من الشر',
        },
      ],
    },
    // أذكار المساء
    {
      'title': 'أذكار المساء',
      'subtitle': 'من أذكار المساء المأثورة',
      'items': [
        {
          'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'repeat': 1,
          'category': 'حفظ وأمان',
        },
        {
          'text': 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ.',
          'repeat': 4,
          'category': 'شهادة التوحيد',
        },
        {
          'text': 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          'repeat': 1,
          'category': 'حمد وشكر',
        },
        {
          'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
          'repeat': 3,
          'category': 'الاستعاذة',
        },
        {
          'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ.',
          'repeat': 1,
          'category': 'دعاء',
        },
      ],
    },
    // أذكار بعد الصلاة
    {
      'title': 'أذكار بعد الصلاة',
      'subtitle': 'من الأذكار المشروعة بعد الصلوات الخمس',
      'items': [
        {
          'text': 'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ. اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
          'repeat': 1,
          'category': 'استغفار',
        },
        {
          'text': 'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
          'repeat': 1,
          'category': 'تسبيح',
        },
        {
          'text': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ.',
          'repeat': 1,
          'category': 'دعاء',
        },
        {
          'text': 'سُبْحَانَ اللَّهِ.',
          'repeat': 33,
          'category': 'تسبيح',
        },
        {
          'text': 'الْحَمْدُ لِلَّهِ.',
          'repeat': 33,
          'category': 'تحميد',
        },
        {
          'text': 'اللَّهُ أَكْبَرُ.',
          'repeat': 33,
          'category': 'تكبير',
        },
        {
          'text': 'لَا إِلَهَ إِلَّا اللَّهُ، وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'repeat': 1,
          'category': 'تهليل',
        },
      ],
    },
    // أذكار النوم
    {
      'title': 'أذكار النوم',
      'subtitle': 'من الأذكار المستحبة قبل النوم',
      'items': [
        {
          'text': 'بِسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.',
          'repeat': 1,
          'category': 'دعاء النوم',
        },
        {
          'text': 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ.',
          'repeat': 1,
          'category': 'دعاء النوم',
        },
        {
          'text': 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ، وَرَبَّ الْأَرْضِ، وَرَبَّ الْعَرْشِ الْعَظِيمِ، رَبَّنَا وَرَبَّ كُلِّ شَيْءٍ، فَالِقَ الْحَبِّ وَالنَّوَى، وَمُنْزِلَ التَّوْرَاةِ وَالْإِنْجِيلِ وَالْفُرْقَانِ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ كُلِّ دَابَّةٍ أَنْتَ آخِذٌ بِنَاصِيَتِهَا، إِنَّ رَبِّي عَلَى صِرَاطٍ مُسْتَقِيمٍ.',
          'repeat': 1,
          'category': 'دعاء النوم',
        },
        {
          'text': 'سُبْحَانَ اللَّهِ.',
          'repeat': 33,
          'category': 'تسبيح',
        },
        {
          'text': 'الْحَمْدُ لِلَّهِ.',
          'repeat': 33,
          'category': 'تحميد',
        },
        {
          'text': 'اللَّهُ أَكْبَرُ.',
          'repeat': 34,
          'category': 'تكبير',
        },
      ],
    },
  ];

  void _copyDhikr(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الذكر'),
        backgroundColor: Color(0xFFD5580F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDhikr = _adhkar[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentDhikr['title']),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.appBarGradient,
          ),
        ),
        bottom: TabBar(
          controller: TabController(length: _adhkar.length, vsync: Navigator.of(context)),
          indicatorColor: const Color(0xFFD5580F),
          tabs: _adhkar.map<Widget>((dhikr) => Tab(text: dhikr['title'])).toList(),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: currentDhikr['items'].length,
          itemBuilder: (context, index) {
            final item = currentDhikr['items'][index];
            final isSelected = _selectedItemIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedItemIndex = isSelected ? null : index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isSelected 
                      ? [
                          const Color(0xFFFFF3E0),
                          const Color(0xFFFFE0B2),
                        ]
                      : [
                          const Color(0xFFFEFEFE),
                          const Color(0xFFF8F8F8),
                        ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFD5580F).withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                        ? const Color(0xFFFF9800).withValues(alpha: 0.3)
                        : const Color(0xFFD5580F).withValues(alpha: 0.1),
                      blurRadius: isSelected ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item['category'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFD5580F),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dhikr text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD5580F).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item['text'],
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.8,
                          color: Color(0xFF1A1A1A),
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Repeat count and copy button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE1C25).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFEE1C25).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${item['repeat']} مرة',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFEE1C25),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () => _copyDhikr(item['text']),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('نسخ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD5580F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
