import 'package:flutter/material.dart';

class DedicationScreen extends StatelessWidget {
  const DedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'صفحة الإهداء والوقف الخيري',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // Header Card
                _HeaderCard(),

                // Sadaqah Jariyah Section
                _SectionWidget(
                  title: 'صدقة جارية ممتدة',
                  content:
                      'هذا العمل المبارك هو صدقة جارية خالصة لوجه الله تعالى مني منصور أحمدباسلمه، وعن أهلي وإخواني جميعاً الأحياء منهم والأموات، راجين لهم المغفرة والرحمة والتوفيق.',
                  icon: Icons.volunteer_activism,
                ),

                // Deceased Persons Section
                _SectionWidget(
                  title: 'نخص بالدعاء والثواب',
                  content: 'نخص بالدعاء الصالح والثواب الجاري:',
                  icon: Icons.people,
                  children: [
                    _DeceasedPersonWidget('المرحوم:جدي عبيد عمر باربود'),
                    _DeceasedPersonWidget('المرحوم: صديقي فهد العرادي'),
                    _DeceasedPersonWidget('المرحوم:عبدالله أبو بكر باعثمان'),
                    _DeceasedPersonWidget('المرحومة: رحمه الهميمي'),
                  ],
                ),

                // Dua Section
                _SectionWidget(
                  title: 'دعاء الختام',
                  content:
                      'اللهم تقبل منا واجعل ثواب هذه الصدقة في صحيفة كل من شارك فيها وكل من انتفع بها. اللهم آنس وحشة أمواتنا ونور قبورهم واجمعنا بهم في جنات النعيم.',
                  icon: Icons.handshake,
                  isDua: true,
                ),

                // Amen Section
                _AmenSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Amiri',
              height: 1.8,
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            'هذا التطبيق، بما يحمله من علم شرعي، هو وقف لله تعالى، ونسأل الله أن يجعله من العلم الذي ينتفع به.',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Amiri',
              height: 1.8,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class _AmenSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 40),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.3)),
      ),
      child: const Text(
        'يا رب العالمين، آمين',
        style: TextStyle(
          fontSize: 22,
          fontFamily: 'Amiri',
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final List<Widget>? children;
  final bool isDua;

  const _SectionWidget({
    required this.title,
    required this.content,
    required this.icon,
    this.children,
    this.isDua = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2E7D32)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 25),
          Text(
            content,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Amiri',
              height: 1.8,
              color: isDua ? const Color(0xFF2E7D32) : Colors.black87,
              fontStyle: isDua ? FontStyle.italic : FontStyle.normal,
            ),
            textAlign: TextAlign.justify,
          ),
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class _DeceasedPersonWidget extends StatelessWidget {
  final String name;

  const _DeceasedPersonWidget(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: Color(0xFF1B5E20), width: 3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Color(0xFF2E7D32), size: 20),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              fontFamily: 'Amiri',
              height: 1.6,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}
