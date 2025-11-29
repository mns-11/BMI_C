#!/usr/bin/env python3
import json

# Load the Tirmidhi data from the repository
with open('/tmp/hadith-json/db/by_book/the_9_books/tirmidhi.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Print information about the data
print(f"Total chapters: {len(data['chapters'])}")
print(f"Total hadiths: {len(data['hadiths'])}")

# Create a mapping of chapter IDs to chapter names
chapter_map = {chapter['id']: chapter for chapter in data['chapters']}

# Group hadiths by chapter
hadiths_by_chapter = {}
for hadith in data['hadiths']:
    chapter_id = hadith['chapterId']
    if chapter_id not in hadiths_by_chapter:
        hadiths_by_chapter[chapter_id] = []
    hadiths_by_chapter[chapter_id].append(hadith)

# Print chapter information
print("\nChapters:")
for chapter_id, chapter in chapter_map.items():
    hadith_count = len(hadiths_by_chapter.get(chapter_id, []))
    print(f"  {chapter['arabic']} (ID: {chapter_id}) - {hadith_count} hadiths")

# Generate Dart code for Tirmidhi hadiths
print("\nGenerating Dart code...")

# Create the TirmidhiHadith model class
dart_code = '''
class TirmidhiHadith {
  final int id;
  final String bookName;
  final int bookNumber;
  final String arabicText;
  final String englishText;
  final String reference;

  TirmidhiHadith({
    required this.id,
    required this.bookName,
    required this.bookNumber,
    required this.arabicText,
    required this.englishText,
    required this.reference,
  });

  factory TirmidhiHadith.fromJson(Map<String, dynamic> json) {
    return TirmidhiHadith(
      id: json['id'] as int,
      bookName: json['bookName'] as String,
      bookNumber: json['bookNumber'] as int,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String,
      reference: json['reference'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': bookName,
      'bookNumber': bookNumber,
      'arabicText': arabicText,
      'englishText': englishText,
      'reference': reference,
    };
  }
}
'''

# Create the TirmidhiService class
dart_code += '''
\nclass TirmidhiService {
  static List<TirmidhiHadith> getAllHadiths() {
    return _getSampleData();
  }

  static List<Map<String, dynamic>> getBooks() {
    final hadiths = getAllHadiths();
    final books = <Map<String, dynamic>>[];
    
    // Group hadiths by book
    final bookGroups = <String, List<TirmidhiHadith>>{};
    for (final hadith in hadiths) {
      if (!bookGroups.containsKey(hadith.bookName)) {
        bookGroups[hadith.bookName] = [];
      }
      bookGroups[hadith.bookName]!.add(hadith);
    }
    
    // Convert to the format expected by the UI
    bookGroups.forEach((bookName, hadiths) {
      books.add({
        'name': bookName,
        'count': hadiths.length,
      });
    });
    
    return books;
  }

  static List<TirmidhiHadith> getHadithsByBook(String bookName) {
    return getAllHadiths()
        .where((hadith) => hadith.bookName == bookName)
        .toList();
  }

  static List<TirmidhiHadith> _getSampleData() {
    return [
'''

# Add hadith data to the Dart code
hadith_counter = 1
for chapter_id, chapter in chapter_map.items():
    chapter_name = chapter['arabic']
    chapter_number = chapter['id']
    
    # Get hadiths for this chapter
    chapter_hadiths = hadiths_by_chapter.get(chapter_id, [])
    
    print(f"Processing chapter: {chapter_name} ({len(chapter_hadiths)} hadiths)")
    
    for hadith in chapter_hadiths:
        # Extract hadith data
        arabic_text = hadith.get('hadith', '').replace('\n', '\\n').replace('"', '\\"')
        
        # Handle English text which might be a dict
        english_data = hadith.get('english', '')
        if isinstance(english_data, dict):
            # Extract narrator and text if available
            narrator = english_data.get('narrator', '')
            text = english_data.get('text', '')
            english_text = f"{narrator} {text}".strip()
        else:
            english_text = str(english_data)
        
        english_text = english_text.replace('\n', '\\n').replace('"', '\\"')
        reference = f"سنن الترمذي - {chapter_name} - حديث {hadith_counter}"
        
        # Add to Dart code
        dart_code += f'''      TirmidhiHadith(
        id: {hadith_counter},
        bookName: '{chapter_name}',
        bookNumber: {chapter_number},
        arabicText: """{arabic_text}""",
        englishText: """{english_text}""",
        reference: '{reference}',
      ),
'''
        hadith_counter += 1

# Close the _getSampleData method and class
dart_code += '''    ];
  }
}
'''

# Write the Dart code to a file
with open('/Users/mansoor/Desktop/Asyic/url/tirmidhi_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print(f"\nGenerated Dart code with {hadith_counter - 1} hadiths")
print("Saved to: /Users/mansoor/Desktop/Asyic/url/tirmidhi_data.dart")