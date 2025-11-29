import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class BukhariHadith {
  final int id;
  final String arabic;
  final String reference;

  BukhariHadith({
    required this.id,
    required this.arabic,
    required this.reference,
  });

  factory BukhariHadith.fromJson(Map<String, dynamic> json) {
    return BukhariHadith(
      id: json['id'],
      arabic: json['arabic'],
      reference: json['reference'],
    );
  }
}

class BukhariHadithScreen extends StatefulWidget {
  final int bookId;
  final String bookName;

  const BukhariHadithScreen({
    Key? key,
    required this.bookId,
    required this.bookName,
  }) : super(key: key);

  @override
  _BukhariHadithScreenState createState() => _BukhariHadithScreenState();
}

class _BukhariHadithScreenState extends State<BukhariHadithScreen> {
  List<BukhariHadith> _hadiths = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/hadiths/bukhari/books/${widget.bookId}.json',
      );
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _hadiths = (data['hadiths'] as List)
            .map((hadith) => BukhariHadith.fromJson(hadith))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في تحميل الأحاديث';
        _isLoading = false;
      });
    }
  }

  void _shareHadith(BukhariHadith hadith) {
    Share.share(
      '${hadith.arabic}\n\n${hadith.reference}',
      subject: 'حديث شريف من صحيح البخاري',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHadiths,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_hadiths.isEmpty) {
      return const Center(child: Text('لا توجد أحاديث متاحة'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: _hadiths.length,
      itemBuilder: (context, index) {
        final hadith = _hadiths[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hadith number and share button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () => _shareHadith(hadith),
                    ),
                    Text(
                      'الحديث رقم ${hadith.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Hadith text
                Text(
                  hadith.arabic,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    fontFamily:
                        'UthmanicHafs', // Make sure to include this font in your pubspec.yaml
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),

                const SizedBox(height: 16),

                // Reference
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hadith.reference,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
