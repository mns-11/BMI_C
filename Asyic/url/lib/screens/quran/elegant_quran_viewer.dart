import 'package:flutter/material.dart';
import 'dart:math' as math;

// Custom painter for Islamic geometric patterns
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          Color(0x1AD4AF37) // Light gold with transparency
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * i / 5, paint);
    }

    // Draw star pattern
    final starPaint = Paint()
      ..color =
          Color(0x2A1A5D1A) // Light green with transparency
      ..style = PaintingStyle.fill;

    final starPath = Path();
    final starRadius = size.width * 0.1;
    final starCenter = Offset(size.width * 0.2, size.height * 0.2);

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final x = starCenter.dx + starRadius * math.cos(angle);
      final y = starCenter.dy + starRadius * math.sin(angle);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);

    // Draw another star pattern
    final starCenter2 = Offset(size.width * 0.8, size.height * 0.8);
    final starPath2 = Path();

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final x = starCenter2.dx + starRadius * math.cos(angle);
      final y = starCenter2.dy + starRadius * math.sin(angle);

      if (i == 0) {
        starPath2.moveTo(x, y);
      } else {
        starPath2.lineTo(x, y);
      }
    }
    starPath2.close();
    canvas.drawPath(starPath2, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ElegantQuranViewer extends StatefulWidget {
  final int pageNumber; // 1..604
  final String? pageText; // Optional text to display

  const ElegantQuranViewer({Key? key, required this.pageNumber, this.pageText})
    : super(key: key);

  @override
  State<ElegantQuranViewer> createState() => _ElegantQuranViewerState();
}

class _ElegantQuranViewerState extends State<ElegantQuranViewer> {
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
      body: Container(
        // Elegant green and gold background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A5D1A), // Deep green
              Color(0xFF3D8B3D), // Medium green
              Color(0xFF1A5D1A), // Deep green
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative Islamic patterns
              Positioned.fill(
                child: CustomPaint(painter: IslamicPatternPainter()),
              ),
              // Main content
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    // Elegant page background with gold border
                    color: Color(0xFFFFF8E1), // Cream color for page
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFD4AF37), // Gold border
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Decorative header
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A5D1A),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(17),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'سورة الفاتحة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Amiri', // Elegant Arabic font
                            ),
                          ),
                        ),
                      ),

                      // Page content area
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Bismillah text (if needed)
                              if (widget.pageNumber == 1) // Only for first page
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFD4AF37),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'QCF_P001', // Madinah font
                                      color: Color(0xFF1A5D1A),
                                      height: 1.8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              // Main Quran text
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.pageText ?? _getDefaultPageText(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily:
                                          'QCF_P${widget.pageNumber.toString().padLeft(3, '0')}',
                                      color: Colors.black87,
                                      height: 2.0,
                                    ),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Page number footer
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A5D1A),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(17),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${_toArabicNumber(widget.pageNumber)} من ${_toArabicNumber(604)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDefaultPageText() {
    // This is a placeholder - in a real app, you would load the actual Quran text
    switch (widget.pageNumber) {
      case 1:
        return '''
بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ
ٱلرَّحْمَٰنِ ٱلرَّحِيمِ
مَٰلِكِ يَوْمِ ٱلدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ
صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ
''';
      default:
        return '''
بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ
الر تِلْكَ آيَٰتُ ٱلْكِتَٰبِ ٱلْمُبِينِ
هُدًى وَبُشْرَىٰ لِلْمُؤْمِنِينَ
ٱلَّذِينَ يُقِيمُونَ ٱلصَّلَوٰةَ وَيُؤْتُونَ ٱلزَّكَوٰةَ وَهُم بِٱلْآخِرَةِ هُمْ يُوقِنُونَ
أُو۟لَٰٓئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ
''';
    }
  }
}
