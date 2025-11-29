import 'package:flutter/material.dart';
import 'lib/services/tirmidhi_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _status = 'Loading...';
  int _hadithCount = 0;

  @override
  void initState() {
    super.initState();
    _testTirmidhiService();
  }

  Future<void> _testTirmidhiService() async {
    try {
      final hadiths = await TirmidhiService.getAllHadiths();
      setState(() {
        _status = 'Success!';
        _hadithCount = hadiths.length;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tirmidhi Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Hadith Count: $_hadithCount', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}