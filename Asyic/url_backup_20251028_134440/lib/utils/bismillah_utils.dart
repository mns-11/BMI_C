// Bismillah utilities for handling the Bismillah in surahs

/// Returns the Bismillah as a map with empty keys to avoid display issues
Map<String, String> getBismillah() {
  return {
    '': 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
    ' ': 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'
  };
}

/// Prepends Bismillah to a list of verses
/// For Al-Fatihah (surahNumber = 1), it will be added as verse 1
/// For other surahs, it will be added as a verse without a number
List<Map<String, dynamic>> prependBismillah(
    List<Map<String, dynamic>> verses, int surahNumber) {
  // For Al-Fatihah, we need to insert it as verse 1 and increment other verse numbers
  if (surahNumber == 1) {
    // Create a copy of the first verse with verseNumber = 1
    final firstVerse = Map<String, dynamic>.from(verses.first);
    firstVerse['verseNumber'] = 1;
    
    // Update verse numbers for the rest of the verses
    final updatedVerses = verses.skip(1).map((verse) {
      final updatedVerse = Map<String, dynamic>.from(verse);
      updatedVerse['verseNumber'] = (verse['verseNumber'] as int) + 1;
      return updatedVerse;
    }).toList();
    
    return [firstVerse, ...updatedVerses];
  } 
  // For other surahs, just prepend the Bismillah without a verse number
  else {
    return [getBismillah(), ...verses];
  }
}
