import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/reciters_screen.dart';
import 'screens/hadith_screen.dart';
import 'screens/adhkar_screen.dart';
import 'screens/prophets_stories_screen.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/dedication_screen.dart';
import 'screens/team_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المكتبة الإسلامية',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      routes: {
        // '/': (context) => const HomeScreen(),
        '/quran': (context) => const QuranScreen(),
        '/reciters': (context) => const RecitersScreen(),
        '/hadith': (context) => const HadithScreen(),
        '/adhkar': (context) => const AdhkarScreen(),
        '/prophets': (context) => const ProphetsStoriesScreen(),
        '/prayer-times': (context) => const PrayerTimesScreen(),
        '/dedication': (context) => const DedicationScreen(),
        '/team': (context) => const TeamScreen(),
      },
    );
  }
}
