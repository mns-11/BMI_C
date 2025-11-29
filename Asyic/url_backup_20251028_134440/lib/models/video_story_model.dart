class VideoStory {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final Duration duration;
  final String description;
  final bool isForKids;
  final String prophetName;
  final String category;

  const VideoStory({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.description,
    required this.isForKids,
    required this.prophetName,
    this.category = 'video',
  });

  static List<VideoStory> getAdultVideos() {
    return [
      VideoStory(
        id: 'adam_1',
        title: 'قصة سيدنا آدم عليه السلام',
        thumbnailUrl: 'assets/images/videos/adam.jpg',
        videoUrl: 'https://example.com/videos/adam.mp4',
        duration: const Duration(minutes: 15),
        description: 'قصة خلق سيدنا آدم عليه السلام وكيفية نزوله إلى الأرض',
        isForKids: false,
        prophetName: 'آدم',
      ),
      VideoStory(
        id: 'nuh_1',
        title: 'قصة سيدنا نوح عليه السلام',
        thumbnailUrl: 'assets/images/videos/nuh.jpg',
        videoUrl: 'https://example.com/videos/nuh.mp4',
        duration: const Duration(minutes: 20),
        description: 'قصة سيدنا نوح عليه السلام مع قومه والسفينة العظيمة',
        isForKids: false,
        prophetName: 'نوح',
      ),
      // Add more adult videos for other prophets
    ];
  }

  static List<VideoStory> getKidsVideos() {
    return [
      VideoStory(
        id: 'adam_kids_1',
        title: 'قصة سيدنا آدم للأطفال',
        thumbnailUrl: 'assets/images/videos/adam_kids.jpg',
        videoUrl: 'https://example.com/videos/adam_kids.mp4',
        duration: const Duration(minutes: 10),
        description: 'قصة جميلة ومبسطة عن سيدنا آدم للأطفال',
        isForKids: true,
        prophetName: 'آدم',
      ),
      VideoStory(
        id: 'nuh_kids_1',
        title: 'قصة سفينة نوح للأطفال',
        thumbnailUrl: 'assets/images/videos/nuh_kids.jpg',
        videoUrl: 'https://example.com/videos/nuh_kids.mp4',
        duration: const Duration(minutes: 12),
        description: 'قصة ممتعة عن سفينة سيدنا نوح والحيوانات',
        isForKids: true,
        prophetName: 'نوح',
      ),
      // Add more kids videos for other prophets
    ];
  }

  static List<VideoStory> getAllVideos({bool? forKids}) {
    if (forKids == true) {
      return getKidsVideos();
    } else if (forKids == false) {
      return getAdultVideos();
    }
    return [...getAdultVideos(), ...getKidsVideos()];
  }

  static List<VideoStory> getVideosByProphet(String prophetName, {bool? forKids}) {
    return getAllVideos(forKids: forKids)
        .where((video) => video.prophetName == prophetName)
        .toList();
  }
}
