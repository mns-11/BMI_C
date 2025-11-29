import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PalestinianAwarenessScreen extends StatefulWidget {
  const PalestinianAwarenessScreen({super.key});

  @override
  State<PalestinianAwarenessScreen> createState() => _PalestinianAwarenessScreenState();
}

class _PalestinianAwarenessScreenState extends State<PalestinianAwarenessScreen> {
  int _currentCampaignIndex = 0;

  final List<Map<String, dynamic>> _campaigns = [
    {
      'title': 'حملة دعم فلسطين',
      'subtitle': 'نصرة القضية الفلسطينية ودعم الصمود',
      'campaigns': [
        {
          'title': 'انتفاضة الأقصى - 2000',
          'description': 'الانتفاضة الفلسطينية الثانية التي اندلعت كرد فعل على الانتهاكات الإسرائيلية في المسجد الأقصى، وأدت إلى خسائر فادحة في صفوف الاحتلال.',
          'date': 'سبتمبر 2000',
          'impact': 'أظهرت صمود الشعب الفلسطيني وقدرته على المقاومة رغم التفوق العسكري الإسرائيلي.',
          'image': 'انتفاضة الأقصى',
          'actions': [
            'مظاهرات سلمية',
            'مقاومة شعبية',
            'إضرابات شاملة',
            'دعم دولي متزايد'
          ],
        },
        {
          'title': 'معركة سيف القدس - 2021',
          'description': 'المواجهة العسكرية التي اندلعت كرد على الاعتداءات الإسرائيلية في القدس والمسجد الأقصى، وشهدت إطلاق آلاف الصواريخ نحو المدن الإسرائيلية.',
          'date': 'مايو 2021',
          'impact': 'أكدت وحدة الشعب الفلسطيني وأظهرت تطور المقاومة الفلسطينية وقدراتها العسكرية.',
          'image': 'معركة سيف القدس',
          'actions': [
            'إطلاق الصواريخ',
            'المقاومة في غزة',
            'مظاهرات في الضفة',
            'تضامن عربي وإسلامي'
          ],
        },
        {
          'title': 'طوفان الأقصى - 2023',
          'description': 'عملية عسكرية شاملة شنتها المقاومة الفلسطينية كرد على الانتهاكات الإسرائيلية المستمرة، وأدت إلى تحرير أراضٍ فلسطينية وأسر جنود إسرائيليين.',
          'date': 'أكتوبر 2023',
          'impact': 'أحدثت تحولاً استراتيجياً في الصراع وأعادت القضية الفلسطينية إلى الواجهة العالمية.',
          'image': 'طوفان الأقصى',
          'actions': [
            'عملية عسكرية شاملة',
            'تحرير أراضي محتلة',
            'أسر جنود إسرائيليين',
            'تأثير إعلامي عالمي'
          ],
        },
        {
          'title': 'يوم الأرض - 1976',
          'description': 'الإضراب العام الذي نظمه الفلسطينيون داخل الأراضي المحتلة عام 1948 احتجاجاً على مصادرة أراضيهم، وأدى إلى استشهاد 6 فلسطينيين.',
          'date': 'مارس 1976',
          'impact': 'أصبح رمزاً للصمود والمقاومة، ويُحتفل به سنوياً كيوم للأرض الفلسطينية.',
          'image': 'يوم الأرض',
          'actions': [
            'إضراب عام شامل',
            'مظاهرات واسعة',
            'رفض المصادرة',
            'توحيد الشعب الفلسطيني'
          ],
        },
        {
          'title': 'مسيرة العودة الكبرى - 2018',
          'description': 'مسيرة سلمية بدأت في غزة للمطالبة بحق العودة ورفع الحصار، واستمرت لأسابيع رغم القمع الإسرائيلي الوحشي.',
          'date': 'مارس 2018',
          'impact': 'أظهرت سلمية المقاومة الفلسطينية وأعادت القضية إلى الواجهة الدولية.',
          'image': 'مسيرة العودة',
          'actions': [
            'مظاهرات سلمية',
            'مطالبة بالعودة',
            'كسر الحصار',
            'تضامن دولي'
          ],
        },
      ],
    },
    {
      'title': 'حملات التوعية',
      'subtitle': 'نشر الوعي بالقضية الفلسطينية عالمياً',
      'campaigns': [
        {
          'title': 'مقاطعة إسرائيل (BDS)',
          'description': 'حركة مقاطعة إسرائيل وسحب الاستثمارات منها وفرض العقوبات عليها، تأسست عام 2005 وأصبحت حركة عالمية.',
          'date': 'منذ 2005',
          'impact': 'أثرت على الاقتصاد الإسرائيلي وأصبحت صوتاً للقضية الفلسطينية في العالم.',
          'image': 'حركة BDS',
          'actions': [
            'مقاطعة البضائع الإسرائيلية',
            'سحب الاستثمارات',
            'العقوبات الدولية',
            'التأثير الإعلامي'
          ],
        },
        {
          'title': 'حملة فلسطين حرة',
          'description': 'حملة إعلامية لنشر الرواية الفلسطينية ودحض الدعاية الإسرائيلية، تركز على حقوق الإنسان والقانون الدولي.',
          'date': 'مستمرة',
          'impact': 'غيرت الرأي العام العالمي ودعمت القضية الفلسطينية في المحافل الدولية.',
          'image': 'فلسطين حرة',
          'actions': [
            'نشر المعلومات الصحيحة',
            'دحض الدعاية الإسرائيلية',
            'دعم في المحافل الدولية',
            'توعية الرأي العام'
          ],
        },
        {
          'title': 'حملة أوقفوا الإبادة في غزة',
          'description': 'حملة لفضح جرائم الحرب الإسرائيلية في غزة ودعوة المجتمع الدولي للتدخل لوقف الإبادة الجماعية.',
          'date': 'منذ 2023',
          'impact': 'ساهمت في عزل إسرائيل دولياً ودعم القضية الفلسطينية في المحاكم الدولية.',
          'image': 'غزة تحت النار',
          'actions': [
            'فضح جرائم الحرب',
            'دعوة للتدخل الدولي',
            'دعم في المحاكم',
            'عزل إسرائيل دولياً'
          ],
        },
      ],
    },
    {
      'title': 'الإنجازات الفلسطينية',
      'subtitle': 'النجاحات والإنجازات رغم الاحتلال',
      'campaigns': [
        {
          'title': 'اعتراف دولي بفلسطين',
          'description': 'اعترفت أكثر من 140 دولة بدولة فلسطين، وأصبحت عضواً مراقباً في الأمم المتحدة.',
          'date': 'منذ 2012',
          'impact': 'تعزيز المكانة الدولية لفلسطين ودعم القضية في المحافل الدولية.',
          'image': 'عضوية الأمم المتحدة',
          'actions': [
            'الاعتراف الدولي',
            'عضوية الأمم المتحدة',
            'تعزيز المكانة الدولية',
            'دعم في المحافل الدولية'
          ],
        },
        {
          'title': 'المقاومة الرقمية',
          'description': 'استخدام وسائل التواصل الاجتماعي لنشر الرواية الفلسطينية وفضح جرائم الاحتلال، وصلت إلى ملايين المشاهدين.',
          'date': 'منذ 2010',
          'impact': 'غيرت الرأي العام العالمي ودعمت القضية الفلسطينية إعلامياً.',
          'image': 'المقاومة الرقمية',
          'actions': [
            'استخدام وسائل التواصل',
            'نشر الرواية الفلسطينية',
            'فضح جرائم الاحتلال',
            'التأثير الإعلامي'
          ],
        },
        {
          'title': 'التطور العلمي والتكنولوجي',
          'description': 'رغم الحصار والاحتلال، حقق الفلسطينيون إنجازات علمية وتكنولوجية مهمة في مختلف المجالات.',
          'date': 'مستمر',
          'impact': 'أثبت قدرة الشعب الفلسطيني على الإبداع والتطور رغم الظروف الصعبة.',
          'image': 'الإنجازات العلمية',
          'actions': [
            'البحث العلمي',
            'التطوير التكنولوجي',
            'الإبداع والابتكار',
            'التحدي والصمود'
          ],
        },
      ],
    },
    {
      'title': 'كيفية المساعدة',
      'subtitle': 'طرق عملية لدعم القضية الفلسطينية',
      'campaigns': [
        {
          'title': 'المقاطعة الاقتصادية',
          'description': 'مقاطعة البضائع والشركات الإسرائيلية، وسحب الاستثمارات من إسرائيل، وفرض العقوبات الدولية.',
          'date': 'فعالة',
          'impact': 'تأثير مباشر على الاقتصاد الإسرائيلي ودعم للاقتصاد الفلسطيني.',
          'image': 'المقاطعة',
          'actions': [
            'مقاطعة البضائع',
            'سحب الاستثمارات',
            'فرض العقوبات',
            'دعم المنتجات الفلسطينية'
          ],
        },
        {
          'title': 'الدعم الإعلامي',
          'description': 'نشر المعلومات الصحيحة عن القضية الفلسطينية، ودحض الدعاية الإسرائيلية، ومشاركة قصص الصمود.',
          'date': 'مستمر',
          'impact': 'تغيير الرأي العام ودعم القضية إعلامياً وسياسياً.',
          'image': 'الدعم الإعلامي',
          'actions': [
            'نشر المعلومات الصحيحة',
            'دحض الدعاية الإسرائيلية',
            'مشاركة قصص الصمود',
            'التأثير الإعلامي'
          ],
        },
        {
          'title': 'الدعم السياسي',
          'description': 'الضغط على الحكومات للاعتراف بفلسطين، ودعم في المحافل الدولية، والتصويت لصالح القضية.',
          'date': 'فعال',
          'impact': 'تعزيز المكانة الدولية لفلسطين ودعم الحقوق الفلسطينية.',
          'image': 'الدعم السياسي',
          'actions': [
            'الضغط على الحكومات',
            'الاعتراف بفلسطين',
            'الدعم في المحافل الدولية',
            'التصويت لصالح القضية'
          ],
        },
        {
          'title': 'الدعم الإنساني',
          'description': 'التبرع للمؤسسات الإنسانية في فلسطين، ودعم العائلات المتضررة، وتقديم المساعدات الطبية والغذائية.',
          'date': 'مستمر',
          'impact': 'تخفيف معاناة الشعب الفلسطيني ودعم صموده في أرضه.',
          'image': 'الدعم الإنساني',
          'actions': [
            'التبرعات للمؤسسات',
            'دعم العائلات المتضررة',
            'المساعدات الطبية',
            'المساعدات الغذائية'
          ],
        },
      ],
    },
  ];

  void _copyContent(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ المحتوى'),
        backgroundColor: Color(0xFF006C3A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCampaign = _campaigns[_currentCampaignIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCampaign['title']),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000000),
                Color(0xFF006C3A),
                Color(0xFFffffff),
                Color(0xFFEE1C25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: TabController(length: _campaigns.length, vsync: Navigator.of(context)),
          indicatorColor: const Color(0xFF006C3A),
          isScrollable: true,
          tabs: _campaigns.map<Widget>((campaign) => Tab(text: campaign['title'])).toList(),
          onTap: (index) {
            setState(() {
              _currentCampaignIndex = index;
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
          itemCount: currentCampaign['campaigns'].length,
          itemBuilder: (context, index) {
            final campaign = currentCampaign['campaigns'][index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
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
                  color: const Color(0xFF006C3A).withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF006C3A).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campaign title
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF000000),
                            Color(0xFF006C3A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        campaign['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE1C25).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEE1C25).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        campaign['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEE1C25),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campaign description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF006C3A).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        campaign['description'],
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xFF1A1A1A),
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Impact section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF006C3A).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF006C3A).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'التأثير والنتائج:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006C3A),
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            campaign['impact'],
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Color(0xFF333333),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Actions section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE1C25).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFEE1C25).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الأنشطة والفعاليات:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEE1C25),
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...campaign['actions'].map<Widget>((action) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFFEE1C25),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  action,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF333333),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Copy button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _copyContent('${campaign['title']}\n\n${campaign['description']}\n\nالتأثير: ${campaign['impact']}'),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('نسخ المعلومات'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006C3A),
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
            );
          },
        ),
      ),
    );
  }
}
