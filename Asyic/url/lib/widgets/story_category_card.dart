import 'package:flutter/material.dart';
import '../models/story_category_model.dart';

class StoryCategoryCard extends StatefulWidget {
  final StoryCategory category;
  final VoidCallback onTap;

  const StoryCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<StoryCategoryCard> createState() => _StoryCategoryCardState();
}

class _StoryCategoryCardState extends State<StoryCategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      child: Card(
        elevation: _isPressed ? 2 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            widget.onTap();
            setState(() => _isPressed = true);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) setState(() => _isPressed = false);
            });
          },
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _isPressed 
                  ? _getPressedGradient()
                  : _getNormalGradient(),
              boxShadow: [
                if (!_isPressed)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getIcon(widget.category.type),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.category.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF333333), // Dark gray for better readability
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          offset: const Offset(0.5, 0.5),
                          blurRadius: 1.0,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getNormalGradient() {
    final color = _getGradientColor(widget.category.type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        Color.lerp(color, Colors.white, 0.7) ?? color,
      ],
    );
  }

  LinearGradient _getPressedGradient() {
    final color = _getGradientColor(widget.category.type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(color, Colors.black, 0.05) ?? color,
        Color.lerp(color, Colors.white, 0.9) ?? color,
      ],
    );
  }

  Widget _getIcon(String type) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    
    switch (type) {
      case 'audio':
        icon = Icons.headphones;
        iconColor = const Color(0xFF00796B); // Dark teal
        backgroundColor = const Color(0xFFE0F2F1); // Light teal
        break;
      case 'video':
        icon = Icons.video_library;
        iconColor = const Color(0xFFE65100); // Dark orange
        backgroundColor = const Color(0xFFFFF3E0); // Light orange
        break;
      case 'text':
      default:
        icon = Icons.menu_book;
        iconColor = const Color(0xFF4A148C); // Dark purple
        backgroundColor = const Color(0xFFEDE7F6); // Light purple
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 32, color: iconColor),
    );
  }

  Color _getGradientColor(String type) {
    switch (type) {
      case 'audio':
        return const Color(0xFFB2DFDB); // Teal
      case 'video':
        return const Color(0xFFFFE0B2); // Orange
      case 'text':
      default:
        return const Color(0xFFD1C4E9); // Purple
    }
  }
}
