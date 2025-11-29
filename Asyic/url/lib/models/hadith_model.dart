class Hadith {
  final int id;
  final String title;
  final String content;
  final String reference;
  final String? audioUrl;

  Hadith({
    required this.id,
    required this.title,
    required this.content,
    required this.reference,
    this.audioUrl,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?) ?? 'حديث شريف',
      content: (json['content'] as String?) ?? '',
      reference: (json['reference'] as String?) ?? 'الراوي: - | المحدث: - | المصدر: -',
      audioUrl: json['audio'] as String?,
    );
  }
}

// Sample data - In a real app, this would come from an API or local JSON file
final List<Hadith> sampleHadiths = [
  Hadith(
    id: 1,
    title: 'من كلام النبي ﷺ',
    content: 'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى، فمن كانت هجرته إلى الله ورسوله فهجرته إلى الله ورسوله، ومن كانت هجرته لدنيا يصيبها أو امرأة ينكحها فهجرته إلى ما هاجر إليه',
    reference: 'رواه البخاري ومسلم',
  ),
  Hadith(
    id: 2,
    title: 'من كلام النبي ﷺ',
    content: 'الدين النصيحة، قلنا: لمن؟ قال: لله، ولكتابه، ولرسوله، ولأئمة المسلمين وعامتهم',
    reference: 'رواه مسلم',
  ),
  // Add more hadiths as needed
];
