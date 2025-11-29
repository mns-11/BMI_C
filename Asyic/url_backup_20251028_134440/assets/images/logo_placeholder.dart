import 'package:flutter/material.dart';

class LogoPlaceholder extends StatelessWidget {
  const LogoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF000000),
            Color(0xFF006C3A),
            Color(0xFFffffff),
            Color(0xFFEE1C25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF006C3A),
          width: 4,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: const Icon(
          Icons.flag,
          color: Color(0xFF006C3A),
          size: 40,
        ),
      ),
    );
  }
}
