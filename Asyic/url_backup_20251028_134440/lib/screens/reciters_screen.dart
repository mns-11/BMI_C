import 'package:flutter/material.dart';
import '../data/reciters_data.dart';
import '../models/reciter.dart';
import '../theme/app_theme.dart';
import 'surah_list_screen.dart';

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
              .where(
                (Reciter reciter) => reciter.name.contains(query),
              )
              .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
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
                  child: ListTile(
                    title: Text(
                      reciter.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(reciter.country),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SurahListScreen(
                            reciter: reciter,
                          ),
                        ),
                      );
                    },
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
