import 'package:flutter/material.dart';
import '../models/abu_dawud_hadith_model.dart';

class AbuDawudBookScreen extends StatefulWidget {
  final String bookName;
  final List<AbuDawudHadith> hadiths;

  const AbuDawudBookScreen({
    Key? key,
    required this.bookName,
    required this.hadiths,
  }) : super(key: key);

  @override
  _AbuDawudBookScreenState createState() => _AbuDawudBookScreenState();
}

class _AbuDawudBookScreenState extends State<AbuDawudBookScreen> {
  double _fontSize = 16.0; // Default font size

  void _increaseFontSize() {
    setState(() {
      _fontSize = _fontSize + 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 10.0) {
        _fontSize = _fontSize - 2.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          // Add font size controls to AppBar
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.hadiths.length,
        itemBuilder: (context, index) {
          final hadith = widget.hadiths[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                hadith.arabicText,
                style: TextStyle(fontSize: _fontSize),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                'الحديث رقم: ${index + 1}',
                style: TextStyle(fontSize: _fontSize - 2),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      '${widget.bookName} - حديث ${index + 1}',
                      style: TextStyle(fontSize: _fontSize + 2),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            hadith.arabicText,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: _fontSize + 2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hadith.englishText,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hadith.reference,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
