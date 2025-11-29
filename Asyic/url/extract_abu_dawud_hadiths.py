#!/usr/bin/env python3
import json

# Load the Abu Dawud data from the repository
with open('/tmp/hadith-json/db/by_book/the_9_books/abudawud.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Find the Taharah chapter
taharah_chapter = None
for chapter in data['chapters']:
    if chapter['arabic'] == 'كتاب الطهارة':
        taharah_chapter = chapter
        break

if taharah_chapter is None:
    print("Could not find 'كتاب الطهارة' chapter")
    exit(1)

# Get all hadiths in the Taharah chapter
taharah_hadiths = [h for h in data['hadiths'] if h['chapterId'] == taharah_chapter['id']]

# Filter hadiths 4 to 100
filtered_hadiths = [h for h in taharah_hadiths if 4 <= h['idInBook'] <= 100]

print(f"Found {len(filtered_hadiths)} hadiths (from 4 to 100) in 'كتاب الطهارة'")

# Generate Dart code for the hadiths
dart_code = "        // Generated from repository data - Hadiths 4 to 100\n"
for i, hadith in enumerate(filtered_hadiths):
    # Combine narrator and text for English translation
    if isinstance(hadith['english'], dict):
        english_text = f"{hadith['english'].get('narrator', '')} {hadith['english'].get('text', '')}".strip()
    else:
        english_text = str(hadith['english'])
    
    # Create reference
    reference = f"سنن أبي داود - {taharah_chapter['arabic']} - حديث {hadith['idInBook']}"
    
    dart_code += f"        AbuDawudHadith(\n"
    dart_code += f"          id: {hadith['idInBook']},\n"
    dart_code += f"          bookName: '{taharah_chapter['arabic']}',\n"
    dart_code += f"          bookNumber: {taharah_chapter['id']},\n"
    dart_code += f"          arabicText: '''{hadith['arabic']}''',\n"
    dart_code += f"          englishText: '''{english_text}''',\n"
    dart_code += f"          reference: '{reference}',\n"
    dart_code += f"        ),\n"

# Save to file
with open('/tmp/abu_dawud_hadiths_4_to_100.txt', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print("Generated Dart code saved to /tmp/abu_dawud_hadiths_4_to_100.txt")