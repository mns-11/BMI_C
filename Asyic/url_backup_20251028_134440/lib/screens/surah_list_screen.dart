import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/reciter.dart';
import '../theme/app_theme.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key, required this.reciter});

  final Reciter reciter;

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<SurahAudio> _filteredSurahs = widget.reciter.surahs;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final String query = _searchController.text.trim();
    setState(() {
      _filteredSurahs = query.isEmpty
          ? widget.reciter.surahs
          : widget.reciter.surahs
              .where((SurahAudio surah) => surah.title.contains(query))
              .toList(growable: false);
    });
  }

  Future<void> _launchInApp(String urlString) async {
    if (urlString.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرابط غير متوفر حالياً.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final Uri url = Uri.parse(urlString);
    final bool canLaunch = await canLaunchUrl(url);

    if (!canLaunch) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح الرابط. تأكد من صلاحيته.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل تشغيل المقطع داخل التطبيق.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciter.name),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.appBarGradient,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.reciter.country,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.reciter.notes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'ابحث عن سورة',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredSurahs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final SurahAudio surah = _filteredSurahs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      surah.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.auto_stories),
                        );
                      },
                    ),
                  ),
                  title: Text(surah.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      final url = surah.youtubeUrl ?? surah.audioUrl;
                      _launchInApp(url);
                    },
                    tooltip: 'تشغيل التلاوة',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
