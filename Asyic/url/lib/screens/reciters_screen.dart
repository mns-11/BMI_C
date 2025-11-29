import 'package:flutter/material.dart';
import '../data/reciters_data.dart';
import '../models/reciter.dart';
import '../theme/app_theme.dart';
// import 'youtube_player_screen.dart';

class RecitersScreen extends StatefulWidget {
  const RecitersScreen({super.key});

  @override
  State<RecitersScreen> createState() => _RecitersScreenState();
}

class _RecitersScreenState extends State<RecitersScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Reciter> _filteredReciters = reciters;

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
      _filteredReciters = query.isEmpty
          ? reciters
          : reciters
                .where((Reciter reciter) => reciter.name.contains(query))
                .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم - الفيديوهات'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.appBarGradient),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'ابحث عن قارئ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredReciters.length,
              itemBuilder: (BuildContext context, int index) {
                final Reciter reciter = _filteredReciters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.green,
                    ),
                    title: Text(
                      reciter.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      reciter.country,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    children: [
                      ...reciter.surahs.map((surah) {
                        return ListTile(
                          leading: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.red,
                            size: 30,
                          ),
                          title: Text(
                            surah.title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                          ),
                          // onTap: () {
                          //   if (videoId != null) {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => YoutubePlayerScreen(
                          //           videoId: videoId!,
                          //           title: '${reciter.name} - ${surah.title}',
                          //         ),
                          //       ),
                          //     );
                          //   }
                          // },
                        );
                      }).toList(),
                    ],
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
