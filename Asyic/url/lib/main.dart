import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/reciters_screen.dart';
import 'screens/hadith_screen.dart' show HadithScreen;
import 'screens/muslim_hadiths_screen.dart';
// import 'screens/abu_dawud_screen.dart'; // Removed this import
import 'screens/adhkar_screen.dart';
import 'screens/prophets_stories_screen.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/dedication_screen.dart';
// import 'screens/first_verses_screen.dart';
import 'screens/surah_ikhlas_screen.dart';
import 'screens/tirmidhi_books_screen.dart'; // Add this import
import 'screens/bukhari_books_screen.dart'; // Add this import
import 'screens/mushaf_screen.dart'; // Add this import for MushafScreen
import 'screens/quran_surahs_screen.dart'; // Add this import for QuranSurahsScreen
import 'screens/quran_pdf_screen.dart'; // Add this import for QuranPdfScreen
import 'screens/quran_collections_screen.dart'; // Add this import for QuranCollectionsScreen
import 'screens/quran/elegant_quran_demo.dart'; // Add this import for ElegantQuranDemo
import 'theme/app_theme.dart'; // Add this import
import 'screens/splash_screen.dart'; // Add splash screen import
import 'screens/onboarding_screen.dart'; // Add onboarding screen import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Check if onboarding has been completed
  Future<bool> _checkOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingCompleted') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المكتبة الإسلامية',
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: _checkOnboardingCompleted(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show splash screen while checking
            return SplashScreen();
          } else if (snapshot.hasData && snapshot.data == true) {
            // Onboarding completed, show home screen
            return const HomeScreen();
          } else {
            // Onboarding not completed, show onboarding screen
            return OnboardingScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(), // Home screen route
        '/quran': (context) => const QuranScreen(),
        '/reciters': (context) =>
            const RecitersScreen(), // Keep reciters route for direct access
        '/hadith': (context) => const HadithScreen(),
        '/bukhari-books': (context) =>
            BukhariBooksScreen(), // Add Bukhari route
        // '/bukhari-hadiths': (context) => const BukhariHadithsScreen(),
        '/muslim-hadiths': (context) => const MuslimHadithsScreen(),
        // '/abu-dawud': (context) => const AbuDawudScreen(), // Removed this route
        '/adhkar': (context) => const AdhkarScreen(),
        '/prophets': (context) => const ProphetsStoriesScreen(),
        '/prayer-times': (context) => const PrayerTimesScreen(),
        '/dedication': (context) => const DedicationScreen(),
        // '/first-verses': (context) => const FirstVersesScreen(),
        '/surah-ikhlas': (context) => const SurahIkhlasScreen(),
        // Add Tirmidhi routes
        '/tirmidhi-books': (context) => TirmidhiBooksScreen(),
        // Add Mushaf route
        '/mushaf': (context) => const MushafScreen(initialPage: 1),
        // Add SurahList route
        '/surah-list': (context) => const QuranSurahsScreen(),
        // Add Quran PDF route
        '/quran-pdf': (context) => const QuranPdfScreen(),
        // Add Quran Collections route
        '/quran-collections': (context) => const QuranCollectionsScreen(),
        // Add Elegant Quran Demo route
        '/elegant-quran': (context) => const ElegantQuranDemo(),
      },
    );
  }
}
