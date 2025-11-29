class QuranPage {
  final int pageNumber;
  final List<Verse> verses;

  const QuranPage({
    required this.pageNumber,
    required this.verses,
  });
}

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
}

// Traditional Quran page structure (simplified for the most common pages)
class QuranPagesData {
  static List<QuranPage> getAllPages() {
    return [
      // Page 1 - Al-Fatihah
      QuranPage(
        pageNumber: 1,
        verses: [
          Verse(
            surahNumber: 1,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translation: 'In the name of Allah, the Gracious, the Merciful',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 2,
            arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            translation: 'All praise belongs to Allah, Lord of all the worlds',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 3,
            arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ',
            translation: 'The Gracious, the Merciful',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 4,
            arabicText: 'مَالِكِ يَوْمِ الدِّينِ',
            translation: 'Master of the Day of Judgment',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 5,
            arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
            translation: 'You alone do we worship, and You alone do we implore for help',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 6,
            arabicText: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
            translation: 'Guide us on the straight path',
          ),
          Verse(
            surahNumber: 1,
            verseNumber: 7,
            arabicText: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
            translation: 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray',
          ),
        ],
      ),

      // Page 2 - Beginning of Al-Baqarah
      QuranPage(
        pageNumber: 2,
        verses: [
          Verse(
            surahNumber: 2,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الم',
            translation: 'In the name of Allah, the Gracious, the Merciful. Alif, Lam, Meem',
          ),
          Verse(
            surahNumber: 2,
            verseNumber: 2,
            arabicText: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ',
            translation: 'This is the Book about which there is no doubt, a guidance for those conscious of Allah',
          ),
          Verse(
            surahNumber: 2,
            verseNumber: 3,
            arabicText: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ',
            translation: 'Who believe in the unseen, establish prayer, and spend out of what We have provided for them',
          ),
          Verse(
            surahNumber: 2,
            verseNumber: 4,
            arabicText: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ',
            translation: 'And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain [in faith]',
          ),
          Verse(
            surahNumber: 2,
            verseNumber: 5,
            arabicText: 'أُولَٰئِكَ عَلَى هُدًى مِنْ رَبِّهِمْ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ',
            translation: 'Those are upon [right] guidance from their Lord, and it is those who are the successful',
          ),
        ],
      ),

      // Page 50 - Middle of Al-Baqarah (Ayat Al-Kursi)
      QuranPage(
        pageNumber: 50,
        verses: [
          Verse(
            surahNumber: 2,
            verseNumber: 255,
            arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
            translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great',
          ),
        ],
      ),

      // Page 100 - Al-Imran
      QuranPage(
        pageNumber: 100,
        verses: [
          Verse(
            surahNumber: 3,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الم',
            translation: 'In the name of Allah, the Gracious, the Merciful. Alif, Lam, Meem',
          ),
          Verse(
            surahNumber: 3,
            verseNumber: 2,
            arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
            translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence',
          ),
        ],
      ),

      // Page 200 - An-Nisa
      QuranPage(
        pageNumber: 200,
        verses: [
          Verse(
            surahNumber: 4,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ مِنْ نَفْسٍ وَاحِدَةٍ وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًا كَثِيرًا وَنِسَاءً وَاتَّقُوا اللَّهَ الَّذِي تَسَاءَلُونَ بِهِ وَالْأَرْحَامَ إِنَّ اللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا',
            translation: 'O mankind, fear your Lord, who created you from one soul and created from it its mate and dispersed from both of them many men and women. And fear Allah, through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer',
          ),
        ],
      ),

      // Page 300 - Al-Maidah
      QuranPage(
        pageNumber: 300,
        verses: [
          Verse(
            surahNumber: 5,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ يَا أَيُّهَا الَّذِينَ آمَنُوا أَوْفُوا بِالْعُقُودِ أُحِلَّتْ لَكُمْ بَهِيمَةُ الْأَنْعَامِ إِلَّا مَا يُتْلَىٰ عَلَيْكُمْ غَيْرَ مُحِلِّي الصَّيْدِ وَأَنْتُمْ حُرُمٌ إِنَّ اللَّهَ يَحْكُمُ مَا يُرِيدُ',
            translation: 'O you who have believed, fulfill [all] contracts. Lawful for you are the animals of grazing livestock except for that which is recited to you [in this Qur\'an] - hunting not being permitted while you are in the state of ihram. Indeed, Allah ordains what He intends',
          ),
        ],
      ),

      // Page 400 - Al-An'am
      QuranPage(
        pageNumber: 400,
        verses: [
          Verse(
            surahNumber: 6,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الْحَمْدُ لِلَّهِ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ وَجَعَلَ الظُّلُمَاتِ وَالنُّورَ ثُمَّ الَّذِينَ كَفَرُوا بِرَبِّهِمْ يَعْدِلُونَ',
            translation: 'In the name of Allah, the Gracious, the Merciful. [All] praise is [due] to Allah, who created the heavens and the earth and made the darkness and the light. Then those who disbelieve equate [others] with their Lord',
          ),
        ],
      ),

      // Page 500 - Al-A'raf
      QuranPage(
        pageNumber: 500,
        verses: [
          Verse(
            surahNumber: 7,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ المص',
            translation: 'In the name of Allah, the Gracious, the Merciful. Alif, Lam, Meem, Sad',
          ),
          Verse(
            surahNumber: 7,
            verseNumber: 2,
            arabicText: 'كِتَابٌ أُنْزِلَ إِلَيْكَ فَلَا يَكُنْ فِي صَدْرِكَ حَرَجٌ مِنْهُ لِتُنْذِرَ بِهِ وَذِكْرَىٰ لِلْمُؤْمِنِينَ',
            translation: 'A Book revealed to you, [O Muhammad] - so let there not be in your breast distress therefrom - that you may warn thereby and as a reminder for the believers',
          ),
        ],
      ),

      // Page 600 - Al-Anfal
      QuranPage(
        pageNumber: 600,
        verses: [
          Verse(
            surahNumber: 8,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ يَسْأَلُونَكَ عَنِ الْأَنْفَالِ قُلِ الْأَنْفَالُ لِلَّهِ وَالرَّسُولِ فَاتَّقُوا اللَّهَ وَأَصْلِحُوا ذَاتَ بَيْنِكُمْ وَأَطِيعُوا اللَّهَ وَرَسُولَهُ إِنْ كُنْتُمْ مُؤْمِنِينَ',
            translation: 'In the name of Allah, the Gracious, the Merciful. They ask you, [O Muhammad], about the bounties [of war]. Say, "The [decision concerning] bounties is for Allah and the Messenger." So fear Allah and amend that which is between you and obey Allah and His Messenger, if you should be believers',
          ),
        ],
      ),

      // Page 604 - An-Nas (Last page)
      QuranPage(
        pageNumber: 604,
        verses: [
          Verse(
            surahNumber: 114,
            verseNumber: 1,
            arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
            translation: 'In the name of Allah, the Gracious, the Merciful. Say, "I seek refuge in the Lord of mankind',
          ),
          Verse(
            surahNumber: 114,
            verseNumber: 2,
            arabicText: 'مَلِكِ النَّاسِ',
            translation: 'The Sovereign of mankind',
          ),
          Verse(
            surahNumber: 114,
            verseNumber: 3,
            arabicText: 'إِلَٰهِ النَّاسِ',
            translation: 'The God of mankind',
          ),
          Verse(
            surahNumber: 114,
            verseNumber: 4,
            arabicText: 'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
            translation: 'From the evil of the retreating whisperer',
          ),
          Verse(
            surahNumber: 114,
            verseNumber: 5,
            arabicText: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
            translation: 'Who whispers [evil] into the breasts of mankind',
          ),
          Verse(
            surahNumber: 114,
            verseNumber: 6,
            arabicText: 'مِنَ الْجِنَّةِ وَالنَّاسِ',
            translation: 'From among the jinn and mankind',
          ),
        ],
      ),
    ];
  }

  static QuranPage getPage(int pageNumber) {
    final pages = getAllPages();
    return pages.firstWhere(
      (page) => page.pageNumber == pageNumber,
      orElse: () => pages.last, // Return last page if not found
    );
  }

  static int getTotalPages() {
    return 604;
  }
}
