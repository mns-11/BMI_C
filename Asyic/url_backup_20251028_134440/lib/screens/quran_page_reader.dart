import 'package:flutter/material.dart';
import '../data/quran_pages.dart';
import '../widgets/page_app_bar.dart';

class QuranPageReader extends StatefulWidget {
  const QuranPageReader({super.key});

  @override
  State<QuranPageReader> createState() => _QuranPageReaderState();
}

class _QuranPageReaderState extends State<QuranPageReader> {
  int currentPage = 1;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= QuranPagesData.getTotalPages()) {
      setState(() {
        currentPage = page;
      });
      _pageController.jumpToPage(page - 1);
    }
  }

  void nextPage() {
    if (currentPage < QuranPagesData.getTotalPages()) {
      goToPage(currentPage + 1);
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      goToPage(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        currentPage: currentPage,
        totalPages: QuranPagesData.getTotalPages(),
        onPageSelected: goToPage,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F4E6), // Cream color
              Color(0xFFE8DCC6), // Light beige
              Color(0xFFD4C4A8), // Warm beige
            ],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: QuranPagesData.getTotalPages(),
          onPageChanged: (page) {
            setState(() {
              currentPage = page + 1;
            });
          },
          itemBuilder: (context, index) {
            final page = QuranPagesData.getAllPages()[index];
            return _buildPageContent(page);
          },
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: "previous",
              onPressed: currentPage > 1 ? previousPage : null,
              backgroundColor: currentPage > 1
                  ? const Color(0xFFB8860B)
                  : Colors.grey,
              tooltip: 'الصفحة السابقة',
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFB8860B),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB8860B).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '$currentPage / ${QuranPagesData.getTotalPages()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: "next",
              onPressed: currentPage < QuranPagesData.getTotalPages() ? nextPage : null,
              backgroundColor: currentPage < QuranPagesData.getTotalPages()
                  ? const Color(0xFFB8860B)
                  : Colors.grey,
              tooltip: 'الصفحة التالية',
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(QuranPage page) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Left page (even pages)
          Expanded(
            child: _buildPageSide(page.pageNumber - 1, true),
          ),
          const SizedBox(width: 8),
          // Right page (odd pages)
          Expanded(
            child: _buildPageSide(page.pageNumber, false),
          ),
        ],
      ),
    );
  }

  Widget _buildPageSide(int pageNum, bool isLeft) {
    final page = QuranPagesData.getPage(pageNum);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F8F8), // Light gray from app theme
            Color(0xFFFEFEFE), // Pure white
            Color(0xFFF5F5F5), // Very light gray
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD5580F).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD5580F).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Enhanced page number with app theme colors
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD5580F),
                    Color(0xFFB8860B),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '$pageNum',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Enhanced verses content
            Expanded(
              child: ListView.builder(
                itemCount: page.verses.length,
                itemBuilder: (context, index) {
                  final verse = page.verses[index];
                  return _buildVerseCard(verse, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseCard(Verse verse, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEFEFE), // Pure white
            Color(0xFFF8F8F8), // Light gray
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD5580F).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD5580F).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced verse number with app theme
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD5580F),
                      Color(0xFFB8860B),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD5580F).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${verse.verseNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Enhanced Arabic text with better styling
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFBF7), // Very light cream
                  Color(0xFFFEFEFE), // Pure white
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD5580F).withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD5580F).withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              verse.arabicText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                height: 1.8,
                fontFamily: 'Amiri',
                color: Color(0xFF1A1A1A), // Darker color for better readability
                shadows: [
                  Shadow(
                    color: Color(0x1AD5580F), // D5580F with 10% opacity
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 12),

          // Enhanced translation with app theme colors
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFEFEFE), // Pure white
                  Color(0xFFF8F8F8), // Light gray
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x1AD5580F), // D5580F with 10% opacity
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Translation header with app theme color
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD5580F),
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'الترجمة:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD5580F),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  verse.translation,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
