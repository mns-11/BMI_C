import 'package:flutter/material.dart';
import '../models/story_category_model.dart';
import '../widgets/story_category_card.dart';
import 'dedication_screen.dart';

class ProphetsStoriesScreen extends StatelessWidget {
  const ProphetsStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قصص الأنبياء'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: const Color(0xFF1A1A1A), // Darker text for selected tab
            unselectedLabelColor: const Color(0xFF555555), // Darker text for unselected tabs
            indicator: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            indicatorWeight: 0.1,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'قصص مقروءة'),
              Tab(text: 'قصص صوتية'),
              Tab(text: 'قصص فيديو'),
            ],
          ),
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
            ),
          ),
          child: TabBarView(
            children: [
              // Text Stories Tab
              _buildCategoryView('text', context),
              // Audio Stories Tab
              _buildCategoryView('audio', context),
              // Video Stories Tab
              _buildCategoryView('video', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryView(String type, BuildContext context) {
    final categories = StoryCategory.getCategories()
        .where((category) => category.type == type)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dedication Card
          if (type == 'text') // Only show in the text stories tab
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DedicationScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'صفحة الإهداء والوقف الخيري',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'إهداء ثواب قراءة القصص',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return StoryCategoryCard(
                  category: category,
                  onTap: () => _navigateToStories(context, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToStories(BuildContext context, StoryCategory category) {
    // TODO: Implement navigation to specific story list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم فتح: ${category.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
