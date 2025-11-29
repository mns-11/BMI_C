import 'package:flutter/material.dart';
import 'elegant_quran_viewer.dart';

class ElegantQuranDemo extends StatelessWidget {
  const ElegantQuranDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض المصحف الراقي'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A5D1A), Color(0xFF3D8B3D)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Light green
              Color(0xFFC8E6C9), // Medium green
              Color(0xFFA5D6A7), // Lighter green
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'المصحف الشريف',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A5D1A),
                  fontFamily: 'Amiri',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'عرض أنيق بنص القرآن الكريم',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1A5D1A),
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElegantQuranViewer(
                        pageNumber: 1, // Start with page 1 (Al-Fatiha)
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A5D1A),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'عرض الصفحة الأولى',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'صفحات أخرى:',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1A5D1A),
                  fontFamily: 'Amiri',
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _buildPageButton(context, 2),
                  _buildPageButton(context, 50),
                  _buildPageButton(context, 100),
                  _buildPageButton(context, 200),
                  _buildPageButton(context, 300),
                  _buildPageButton(context, 400),
                  _buildPageButton(context, 500),
                  _buildPageButton(context, 604),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(BuildContext context, int pageNumber) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElegantQuranViewer(
              pageNumber: pageNumber,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3D8B3D),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        '$pageNumber',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'Amiri',
        ),
      ),
    );
  }
}