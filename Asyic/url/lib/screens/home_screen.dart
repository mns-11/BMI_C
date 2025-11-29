import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/home_screen_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكتبة الإسلامية'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.appBarGradient),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[200]!],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quran Card
            HomeScreenItem(
              height: 150,
              text: 'القرآن الكريم',
              imagePath:
                  'assets/images/bee43d6de93dbd60fc7c0943ec071779.png.webp',
              onTap: () {
                Navigator.of(context).pushNamed('/surah-list');
              },
            ),
            const SizedBox(height: 20),
            // Elegant Quran Viewer Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/elegant-quran');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A5D1A),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'عرض المصحف الراقي',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Main Menu Grid
            Expanded(
              child: GridView.builder(
                itemCount: 5, // Changed back to 5
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (BuildContext context, int index) {
                  // Create menu items for other sections
                  switch (index) {
                    case 0:
                      return HomeScreenItem(
                        text: 'قائمة القراء',
                        imagePath:
                            'assets/images/839fa1a43d6988809d0796f619eba1c8.jpg',
                        onTap: () {
                          Navigator.of(context).pushNamed('/reciters');
                        },
                      );
                    case 1:
                      return HomeScreenItem(
                        text: 'الحديث النبوية',
                        imagePath: 'assets/images/images-ح.png',
                        onTap: () {
                          Navigator.of(context).pushNamed('/hadith');
                        },
                      );
                    case 2:
                      return HomeScreenItem(
                        text: 'أذكار الصباح والمساء',
                        imagePath: 'assets/images/images-ا.png',
                        onTap: () {
                          Navigator.of(context).pushNamed('/adhkar');
                        },
                      );
                    case 3:
                      return HomeScreenItem(
                        text: 'أوقات الصلاة',
                        imagePath:
                            'assets/images/839fa1a43d6988809d0796f619eba1c8.jpg', // Using existing image
                        onTap: () {
                          Navigator.of(context).pushNamed('/prayer-times');
                        },
                      );
                    case 4:
                      return HomeScreenItem(
                        text: 'صفحة الإهداء والوقف الخيري',
                        imagePath:
                            'assets/images/bee43d6de93dbd60fc7c0943ec071779.png.webp', // Using existing image
                        onTap: () {
                          Navigator.of(context).pushNamed('/dedication');
                        },
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
