import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DedicationScreen extends StatelessWidget {
  const DedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة الإهداء والوقف الخيري'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.appBarGradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Amiri',
                    height: 1.8,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'هذا التطبيق، بما يحمله من علم شرعي، هو وقف لله تعالى، ونسأل الله أن يجعله من العلم الذي ينتفع به.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    height: 1.8,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                const Text(
                  'صدقة جارية ممتدة:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'هذا العمل المبارك هو صدقة جارية خالصة لوجه الله تعالى مني (اسمك الكريم)، وعن أهلي وإخواني جميعاً الأحياء منهم والأموات، راجين لهم المغفرة والرحمة والتوفيق.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    height: 1.8,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                const Text(
                  'كما نخص بالدعاء الصالح والثواب الجاري:',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDeceasedPerson('المرحوم: (اسم الرجل الأول المتوفى)'),
                _buildDeceasedPerson('المرحوم: (اسم الرجل الثاني المتوفى)'),
                _buildDeceasedPerson('المرحومة: (اسم المرأة المتوفاة)'),
                const SizedBox(height: 24),
                const Text(
                  'اللهم تقبل منا واجعل ثواب هذه الصدقة في صحيفة كل من شارك فيها وكل من انتفع بها. اللهم آنس وحشة أمواتنا ونور قبورهم واجمعنا بهم في جنات النعيم.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    height: 1.8,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'يا رب العالمين، آمين.',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeceasedPerson(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Amiri',
          height: 1.6,
        ),
      ),
    );
  }
}
