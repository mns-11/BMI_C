import '../models/reciter.dart';
import 'surah_catalog.dart';

String _buildAudioUrl(String reciterName, String surahTitle) {
  // Create direct audio URLs from reliable sources
  final String cleanReciterName = reciterName
      .replaceAll('الشيخ ', '')
      .replaceAll(' ', '_')
      .toLowerCase();
  final String cleanSurahTitle = surahTitle
      .replaceAll('سورة ', '')
      .replaceAll(' ', '_')
      .toLowerCase();

  // Using a reliable audio source - you can replace this with actual audio URLs
  // For now, using a format that might work with some Quran audio services
  return 'https://download.quranicaudio.com/quran/$cleanReciterName/${cleanSurahTitle}_128kbps.mp3';
}

String _buildAlternativeAudioUrl(String reciterName, String surahTitle) {
  // Alternative source for audio files
  final String cleanReciterName = reciterName
      .replaceAll('الشيخ ', '')
      .replaceAll(' ', '_')
      .toLowerCase();
  final String cleanSurahTitle = surahTitle
      .replaceAll('سورة ', '')
      .replaceAll(' ', '_')
      .toLowerCase();

  return 'https://everyayah.com/data/$cleanReciterName/${cleanSurahTitle}_128kbps.mp3';
}

String _buildYouTubeSearchUrl(String reciterName, String surahTitle) {
  final String query = '$reciterName $surahTitle تلاوة';
  return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}';
}

List<SurahAudio> _allSurahsForReciter(String reciterName) {
  return kSurahNames.asMap().entries.map((MapEntry<int, String> entry) {
    final int index = entry.key;
    final String surahTitle = entry.value;
    final String imageUrl = surahImageUrl(index + 1);

    // Try multiple audio sources, fallback to YouTube search
    final String directAudioUrl = _buildAudioUrl(reciterName, surahTitle);
    final String alternativeAudioUrl = _buildAlternativeAudioUrl(reciterName, surahTitle);
    final String fallbackYouTubeUrl = _buildYouTubeSearchUrl(reciterName, surahTitle);

    return SurahAudio(
      title: surahTitle,
      imageUrl: imageUrl,
      audioUrl: directAudioUrl, // Try direct audio first
      alternativeAudioUrl: alternativeAudioUrl, // Alternative audio source
      youtubeUrl: fallbackYouTubeUrl, // Fallback to YouTube
    );
  }).toList(growable: false);
}

final List<Reciter> reciters = List<Reciter>.unmodifiable(<Reciter>[
  Reciter(
    name: 'الشيخ عبد الباسط عبد الصمد',
    country: 'مصر 🇪🇬',
    notes:
        '(عميد قراء العصر) يتميز بالصوت القوي والقرار والجوابات المتعددة، وبراعة في المقامات.',
    surahs: _allSurahsForReciter('الشيخ عبد الباسط عبد الصمد'),
  ),
  Reciter(
    name: 'الشيخ محمد صديق المنشاوي',
    country: 'مصر 🇪🇬',
    notes:
        '(صاحب الصوت الباكي) يتميز بجمالية الحزن في صوته والخشوع العميق والتمكن من أحكام التجويد.',
    surahs: _allSurahsForReciter('الشيخ محمد صديق المنشاوي'),
  ),
  Reciter(
    name: 'الشيخ مصطفى إسماعيل',
    country: 'مصر 🇪🇬',
    notes:
        '(أستاذ المقامات) يتميز بالصوت العريض والتنقل البارع بين المقامات والأسلوب الدرامي في التلاوة.',
    surahs: _allSurahsForReciter('الشيخ مصطفى إسماعيل'),
  ),
  Reciter(
    name: 'الشيخ محمود خليل الحصري',
    country: 'مصر 🇪🇬',
    notes:
        '(شيخ المقارئ) يتميز بالأسلوب التعليمي المتقن والتحقيق الدقيق لأحكام التجويد، وهو مرجع في القراءات.',
    surahs: _allSurahsForReciter('الشيخ محمود خليل الحصري'),
  ),
  Reciter(
    name: 'الشيخ عبد الرحمن السديس',
    country: 'السعودية 🇸🇦',
    notes:
        '(إمام الحرم المكي) يتميز بالصوت الجهوري المؤثر والخشوع، والابتهالات في نهاية التلاوة.',
    surahs: _allSurahsForReciter('الشيخ عبد الرحمن السديس'),
  ),
  Reciter(
    name: 'الشيخ ماهر المعيقلي',
    country: 'السعودية 🇸🇦',
    notes:
        '(إمام الحرم المكي) يتميز بالصوت الندي الهادئ والتلاوة المرتلة ذات النبرة الخاشعة والمريحة.',
    surahs: _allSurahsForReciter('الشيخ ماهر المعيقلي'),
  ),
  Reciter(
    name: 'الشيخ سعود الشريم',
    country: 'السعودية 🇸🇦',
    notes:
        '(إمام الحرم المكي سابقاً) يتميز بالجمع بين قوة الصوت والخشوع العميق والالتزام بالترتيل.',
    surahs: _allSurahsForReciter('الشيخ سعود الشريم'),
  ),
  Reciter(
    name: 'الشيخ ياسر الدوسري',
    country: 'السعودية 🇸🇦',
    notes:
        '(إمام الحرم المكي) يتميز بالصوت الجميل والقوي مع نبرة حماسية مميزة في صلاة التراويح.',
    surahs: _allSurahsForReciter('الشيخ ياسر الدوسري'),
  ),
  Reciter(
    name: 'الشيخ ناصر القطامي',
    country: 'السعودية 🇸🇦',
    notes: 'يتميز بالصوت العذب والتلاوة الهادئة ذات النفس الطويل والمؤثرة.',
    surahs: _allSurahsForReciter('الشيخ ناصر القطامي'),
  ),
  Reciter(
    name: 'الشيخ مشاري بن راشد العفاسي',
    country: 'الكويت 🇰🇼',
    notes:
        'يتميز بالجمع بين القراءة والإنشاد، وصوته الرخيم الشجي الذي يحظى بشعبية عالمية.',
    surahs: _allSurahsForReciter('الشيخ مشاري بن راشد العفاسي'),
  ),
  Reciter(
    name: 'الشيخ محمد أيوب',
    country: 'السعودية 🇸🇦',
    notes:
        '(إمام المسجد النبوي سابقاً) يتميز بالصوت الفخم والتلاوة المتقنة والمحكمة في الترتيل.',
    surahs: _allSurahsForReciter('الشيخ محمد أيوب'),
  ),
  Reciter(
    name: 'الشيخ سعد الغامدي',
    country: 'السعودية 🇸🇦',
    notes: 'يتميز بأسلوبه السلس الجميل والواضح، وتلاوته المريحة للنفس.',
    surahs: _allSurahsForReciter('الشيخ سعد الغامدي'),
  ),
  Reciter(
    name: 'الشيخ عبد الله بصفر',
    country: 'السعودية 🇸🇦',
    notes:
        'يتميز بالصوت الهادئ والتلاوة المرتلة، ويُعد من أوائل من نشروا تسجيلات التلاوة المعاصرة.',
    surahs: _allSurahsForReciter('الشيخ عبد الله بصفر'),
  ),
  Reciter(
    name: 'الشيخ أبو بكر الشاطري',
    country: 'السعودية 🇸🇦',
    notes:
        'يتميز بنبرة صوت خاشعة ومؤثرة جداً، وتلاوته البطيئة والمركزة.',
    surahs: _allSurahsForReciter('الشيخ أبو بكر الشاطري'),
  ),
  Reciter(
    name: 'الشيخ حاتم فريد الواعر',
    country: 'مصر 🇪🇬',
    notes: 'يتميز بالتلاوة المتقنة والجميلة، وحظي بشهرة واسعة مؤخراً.',
    surahs: _allSurahsForReciter('الشيخ حاتم فريد الواعر'),
  ),
  Reciter(
    name: 'الشيخ وديع اليمني',
    country: 'اليمن 🇾🇪',
    notes: 'يتميز بالصوت العذب والأسلوب الهادئ المميز في التلاوة.',
    surahs: _allSurahsForReciter('الشيخ وديع اليمني'),
  ),
  Reciter(
    name: 'الشيخ خالد القحطاني',
    country: 'السعودية 🇸🇦',
    notes: 'يتميز بالصوت الجهور القوي والتلاوة الحماسية.',
    surahs: _allSurahsForReciter('الشيخ خالد القحطاني'),
  ),
  Reciter(
    name: 'الشيخ صلاح بو خاطر',
    country: 'الإمارات 🇦🇪',
    notes: 'يتميز بأسلوبه الرقيق الهادئ وتلاوته التي تلامس القلوب.',
    surahs: _allSurahsForReciter('الشيخ صلاح بو خاطر'),
  ),
  Reciter(
    name: 'الشيخ إدريس أبكر',
    country: 'السعودية 🇸🇦',
    notes: 'يتميز بأسلوبه المُحقق والتلاوة ذات الطابع العاطفي والعميق.',
    surahs: _allSurahsForReciter('الشيخ إدريس أبكر'),
  ),
  Reciter(
    name: 'الشيخ عبد الرشيد صوفي',
    country: 'الصومال / قطر 🇸🇴🇶🇦',
    notes:
        'يتميز بإتقان عالي لقراءة ورش عن نافع، وصوته القوي والدافئ.',
    surahs: _allSurahsForReciter('الشيخ عبد الرشيد صوفي'),
  ),
]);
