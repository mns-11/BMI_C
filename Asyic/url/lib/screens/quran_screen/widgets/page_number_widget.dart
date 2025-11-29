import 'package:flutter/material.dart';

class PageNumberWidget extends StatelessWidget {
  final int pageNumber;

  const PageNumberWidget(this.pageNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('$pageNumber', textAlign: TextAlign.center),
    );
  }
}
