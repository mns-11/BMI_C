class Verse {
  final int surahNumber;
  final int verseNumber;
  final String arabicText;
  final String translation;

  const Verse({
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
  });
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      surahNumber: json['surahNumber'],
      verseNumber: json['verseNumber'],
      arabicText: json['arabicText'],
      translation: json['translation'],
    );
  }
}

// Data for Surah An-Nas (114)
final List<Map<String, dynamic>> surahAnNasVerses = [
  {
    'surahNumber': 114,
    'verseNumber': 1,
    'arabicText': 'قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
    'translation': 'Say, "I seek refuge in the Lord of mankind,'
  },
  {
    'surahNumber': 114,
    'verseNumber': 2,
    'arabicText': 'مَلِكِ ٱلنَّاسِ',
    'translation': 'The Sovereign of mankind.'
  },
  {
    'surahNumber': 114,
    'verseNumber': 3,
    'arabicText': 'إِلَٰهِ ٱلنَّاسِ',
    'translation': 'The God of mankind,'
  },
  {
    'surahNumber': 114,
    'verseNumber': 4,
    'arabicText': 'مِن شَرِّ ٱلۡوَسۡوَاسِ ٱلۡخَنَّاسِ',
    'translation': 'From the evil of the retreating whisperer -'
  },
  {
    'surahNumber': 114,
    'verseNumber': 5,
    'arabicText': 'ٱلَّذِي يُوَسۡوِسُ فِي صُدُورِ ٱلنَّاسِ',
    'translation': 'Who whispers [evil] into the breasts of mankind -'
  },
  {
    'surahNumber': 114,
    'verseNumber': 6,
    'arabicText': 'مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ',
    'translation': 'From among the jinn and mankind."'
  },
];

final List<Verse> versesAnNas = surahAnNasVerses.map((verse) => Verse.fromJson(verse)).toList();

// Data for Surah Al-Fatiha (1)
final List<Map<String, dynamic>> surahAlFatihaVerses = [
  {
    'surahNumber': 1,
    'verseNumber': 1,
    'arabicText': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'translation': 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'
  },
  {
    'surahNumber': 1,
    'verseNumber': 2,
    'arabicText': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'translation': '[All] praise is [due] to Allah, Lord of the worlds -'
  },
  {
    'surahNumber': 1,
    'verseNumber': 3,
    'arabicText': 'الرَّحْمَٰنِ الرَّحِيمِ',
    'translation': 'The Entirely Merciful, the Especially Merciful,'
  },
  {
    'surahNumber': 1,
    'verseNumber': 4,
    'arabicText': 'مَالِكِ يَوْمِ الدِّينِ',
    'translation': 'Sovereign of the Day of Recompense.'
  },
  {
    'surahNumber': 1,
    'verseNumber': 5,
    'arabicText': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'translation': 'It is You we worship and You we ask for help.'
  },
  {
    'surahNumber': 1,
    'verseNumber': 6,
    'arabicText': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'translation': 'Guide us to the straight path -'
  },
  {
    'surahNumber': 1,
    'verseNumber': 7,
    'arabicText': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    'translation': 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.'
  },
];

final List<Verse> versesAlFatiha = surahAlFatihaVerses.map((verse) => Verse.fromJson(verse)).toList();

