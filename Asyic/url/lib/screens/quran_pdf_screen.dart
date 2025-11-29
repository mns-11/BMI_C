import 'package:flutter/material.dart';

class QuranPdfScreen extends StatelessWidget {
  final int initialPage;

  const QuranPdfScreen({super.key, this.initialPage = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المصحف - صفحة $initialPage')),
      body: Center(
        child: Text('عرض المصحف (صفحة $initialPage) — هذه شاشة تجريبية.'),
      ),
    );
  }
}
