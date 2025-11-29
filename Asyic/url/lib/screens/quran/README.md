# Elegant Quran Viewer

This feature provides an elegant display of Quran text with the following characteristics:

## Features

1. **Authentic Madinah Mushaf Font**: Uses the official King Fahd Quran Printing Complex fonts (QCF_P001-QCF_P604)
2. **Islamic Decorative Elements**: 
   - Green and gold color scheme representing Islamic tradition
   - Geometric Islamic patterns in the background
   - Gold borders and decorative elements
3. **High-Quality Display**:
   - Professional layout with proper text formatting
   - Page numbers in Arabic numerals
   - Bismillah display for appropriate surahs
4. **Responsive Design**: Adapts to different screen sizes

## Files

- `elegant_quran_viewer.dart`: Main viewer component
- `elegant_quran_demo.dart`: Demo screen to showcase the viewer
- `IslamicPatternPainter`: Custom painter for decorative Islamic patterns

## Usage

The elegant Quran viewer can be accessed through the home screen button "عرض المصحف الراقي" or directly via the route `/elegant-quran`.

## Integration

To use the elegant Quran viewer in your app:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ElegantQuranViewer(
      pageNumber: 1, // Page number (1-604)
      pageText: "Optional custom text", // Optional
    ),
  ),
);
```

## Design Elements

- **Colors**: Deep green (#1A5D1A), medium green (#3D8B3D), gold (#D4AF37)
- **Fonts**: Madinah Mushaf fonts (QCF_P series), Amiri for UI text
- **Layout**: Elegant page with decorative borders and shadows
- **Patterns**: Custom geometric Islamic patterns in the background

This implementation maintains the sanctity of the Quran text while providing a beautiful, professional display suitable for mobile devices.