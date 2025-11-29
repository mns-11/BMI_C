import 'package:flutter/material.dart';

class SurahAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const SurahAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'Amiri',
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFB8860B), // Golden color
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: const Color(0xFFB8860B).withValues(alpha: 0.3),
      leading: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(0), // Reset any rotation
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      leadingWidth: 56, // Ensure enough space for the icon
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
