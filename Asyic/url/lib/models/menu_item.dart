import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.title,
    required this.description,
    this.icon, // هذا يجعلها اختيارية في البناء
    required this.color,
    required this.routeName,
  });

  final String title;
  final String description;
  final IconData? icon; // ⬅️ الإصلاح: جعل 'icon' يقبل القيمة الفارغة (Nullable)
  final Color color;
  final String routeName;
}
