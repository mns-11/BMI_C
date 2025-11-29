class YouTubeVideoModel {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final Duration duration;

  YouTubeVideoModel({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.duration,
  });

  factory YouTubeVideoModel.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoModel(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      duration: Duration(seconds: int.parse(json['contentDetails']['duration']
          .replaceAll('PT', '')
          .replaceAll('H', ':')
          .replaceAll('M', ':')
          .replaceAll('S', '')
          .split(':')
          .reversed
          .toList()
          .asMap()
          .map((i, e) => MapEntry(i, int.parse(e)))
          .values
          .reduce((a, b) => a * 60 + b))),
    );
  }
}
