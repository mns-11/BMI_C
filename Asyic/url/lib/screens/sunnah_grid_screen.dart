import 'package:flutter/material.dart';
import '../services/anas_hadiths_service.dart';
import 'hadith_detail_screen.dart';

class SunnahGridScreen extends StatefulWidget {
  const SunnahGridScreen({Key? key}) : super(key: key);

  @override
  _SunnahGridScreenState createState() => _SunnahGridScreenState();
}

class _SunnahGridScreenState extends State<SunnahGridScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _hadiths = [];

  @override
  void initState() {
    super.initState();
    _loadHadiths();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final hadiths = await AnasHadithsService.getAnasHadiths();
      setState(() {
        _hadiths.addAll(hadiths);
      });
    } catch (e) {
      print('Error loading hadiths: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في تحميل الأحاديث')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadHadiths();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'السنة النبوية',
          style: TextStyle(fontFamily: 'UthmanicHafs'),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hadiths.isEmpty && !_isLoading) {
      return const Center(
        child: Text('لا توجد أحاديث متاحة', style: TextStyle(fontSize: 18)),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _hadiths.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _hadiths.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final hadith = _hadiths[index];
        return _buildHadithCard(hadith);
      },
    );
  }

  Widget _buildHadithCard(Map<String, dynamic> hadith) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithDetailScreen(hadith: hadith),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hadith['title'] ?? 'حديث شريف',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'UthmanicHafs',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  hadith['content'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'UthmanicHafs',
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hadith['reference'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'UthmanicHafs',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
