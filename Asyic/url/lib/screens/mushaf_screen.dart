import 'package:flutter/material.dart';

class MushafScreen extends StatefulWidget {
  final int initialPage; // 1..604

  const MushafScreen({Key? key, required this.initialPage}) : super(key: key);

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late PageController _pageController;
  static const int _totalPages = 604;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: (widget.initialPage - 1).clamp(0, _totalPages - 1),
    );
    _currentPage = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _toArabicNumber(int number) {
    final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المصحف - صفحة ${_toArabicNumber(_currentPage)}'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1967D2), Color(0xFF2196F3)],
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        reverse: true,
        itemCount: _totalPages,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index + 1;
          });
        },
        itemBuilder: (context, index) {
          final pageNumber = index + 1;
          final imageUrl =
              'https://cdn.islamic.network/quran/pages/png/$pageNumber.png';

          return Container(
            color: Colors.white,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
    );
  }
}
