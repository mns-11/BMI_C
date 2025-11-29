class Reciter {
  const Reciter({
    required this.name,
    required this.country,
    required this.notes,
    required this.surahs,
  });

  final String name;
  final String country;
  final String notes;
  final List<SurahAudio> surahs;
}

class SurahAudio {
  const SurahAudio({
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
    this.alternativeAudioUrl,
    this.youtubeUrl,
  });

  final String title;
  final String imageUrl;
  final String audioUrl;
  final String? alternativeAudioUrl;
  final String? youtubeUrl;
}
