import 'package:flutter/material.dart';
import 'quran_surahs_screen.dart';
import 'reciters_screen.dart';
import '../theme/app_theme.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.appBarGradient,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'السور'),
              Tab(text: 'القراء'),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 14),
          ),
        ),
        body: const TabBarView(
          children: [
            QuranSurahsScreen(),
            RecitersScreen(),
          ],
        ),
      ),
    );
  }
}
