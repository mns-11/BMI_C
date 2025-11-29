import 'package:flutter/material.dart';

class HomeScreenItem extends StatefulWidget {
  final String text;
  final String imagePath;
  final double? height;
  final void Function()? onTap;

  const HomeScreenItem({
    super.key,
    required this.text,
    required this.imagePath,
    this.height,
    this.onTap,
  });

  @override
  _HomeScreenItemState createState() => _HomeScreenItemState();
}

class _HomeScreenItemState extends State<HomeScreenItem> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _scale = 1.2;
        });
      },
      onTapUp: (details) {
        setState(() {
          _scale = 1;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1;
        });
      },
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        height: widget.height ?? double.infinity,
        foregroundDecoration: BoxDecoration(
          color: Colors.orange.withAlpha(13), // 5% opacity
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(
              widget.imagePath,
            ),
            fit: BoxFit.cover,
            opacity: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128), // 50% opacity
              blurRadius: 10,
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: _scale,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                  Shadow(
                    color: Colors.black,
                    offset: Offset(-2, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}