#!/usr/bin/env python3
import json

# Load the Muslim data from the repository
with open('/tmp/hadith-json/db/by_book/the_9_books/muslim.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Create a mapping of chapter IDs to chapter names
chapter_map = {chapter['id']: chapter for chapter in data['chapters']}

# Group hadiths by chapter
hadiths_by_chapter = {}
for hadith in data['hadiths']:
    chapter_id = hadith['chapterId']
    if chapter_id not in hadiths_by_chapter:
        hadiths_by_chapter[chapter_id] = []
    hadiths_by_chapter[chapter_id].append(hadith)

# Create the JSON structure for Muslim hadiths
muslim_data = []

# Add hadith data to the JSON structure
hadith_counter = 1
for chapter_id, chapter in chapter_map.items():
    chapter_name = chapter['arabic']
    chapter_number = chapter['id']
    
    # Get hadiths for this chapter
    chapter_hadiths = hadiths_by_chapter.get(chapter_id, [])
    
    print(f"Processing chapter: {chapter_name} ({len(chapter_hadiths)} hadiths)")
    
    for hadith in chapter_hadiths:
        # Extract hadith data
        arabic_text = hadith.get('arabic', '')
        
        # Handle English text which might be a dict
        english_data = hadith.get('english', '')
        if isinstance(english_data, dict):
            # Extract narrator and text if available
            narrator = english_data.get('narrator', '')
            text = english_data.get('text', '')
            english_text = f"{narrator} {text}".strip()
        else:
            english_text = str(english_data)
        
        reference = f"صحيح مسلم - {chapter_name} - حديث {hadith_counter}"
        
        # Add to JSON structure
        muslim_data.append({
            "id": hadith_counter,
            "bookName": chapter_name,
            "bookNumber": chapter_number,
            "arabicText": arabic_text,
            "englishText": english_text,
            "reference": reference
        })
        
        hadith_counter += 1

# Create the directory structure if it doesn't exist
import os
os.makedirs('/Users/mansoor/Desktop/Asyic/url/assets/data/hadiths', exist_ok=True)

# Write the JSON data to a file
with open('/Users/mansoor/Desktop/Asyic/url/assets/data/hadiths/muslim_data.json', 'w', encoding='utf-8') as f:
    json.dump(muslim_data, f, ensure_ascii=False, indent=2)

print(f"\nGenerated JSON file with {hadith_counter - 1} hadiths")
print("Saved to: /Users/mansoor/Desktop/Asyic/url/assets/data/hadiths/muslim_data.json")