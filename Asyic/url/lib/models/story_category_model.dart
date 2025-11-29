class StoryCategory {
  final String id;
  final String title;
  final String imagePath;
  final String type; // 'audio', 'text', or 'video'
  final String audience; // 'kids' or 'adults'

  StoryCategory({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.type,
    required this.audience,
  });

  static List<StoryCategory> getCategories() {
    return [
      // Audio Categories
      StoryCategory(
        id: 'audio_kids',
        title: 'قصص صوتية للأطفال',
        imagePath: 'assets/images/audio_kids.jpg',
        type: 'audio',
        audience: 'kids',
      ),
      StoryCategory(
        id: 'audio_adults',
        title: 'قصص صوتية للكبار',
        imagePath: 'assets/images/audio_adults.jpg',
        type: 'audio',
        audience: 'adults',
      ),
      
      // Text Categories
      StoryCategory(
        id: 'text_kids',
        title: 'قصص مقروءة للأطفال',
        imagePath: 'assets/images/text_kids.jpg',
        type: 'text',
        audience: 'kids',
      ),
      StoryCategory(
        id: 'text_adults',
        title: 'قصص مقروءة للكبار',
        imagePath: 'assets/images/text_adults.jpg',
        type: 'text',
        audience: 'adults',
      ),
      
      // Video Categories
      StoryCategory(
        id: 'video_kids',
        title: 'قصص مصورة للأطفال',
        imagePath: 'assets/images/video_kids.jpg',
        type: 'video',
        audience: 'kids',
      ),
      StoryCategory(
        id: 'video_adults',
        title: 'قصص مصورة للكبار',
        imagePath: 'assets/images/video_adults.jpg',
        type: 'video',
        audience: 'adults',
      ),
    ];
  }
}
