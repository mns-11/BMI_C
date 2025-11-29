import 'package:flutter/material.dart';

class BmiEntity {
  final double result;
  final bool isMale;
  final int age;
  final double height;
  final double weight;

  const BmiEntity({
    required this.result,
    required this.isMale,
    required this.age,
    required this.height,
    required this.weight,
  });

  String get bmiCategory {
    if (result >= 30) return 'Obesity';
    if (result >= 25) return 'Overweight';
    if (result >= 18.5) return 'Normal';
    return 'Underweight';
  }

  Color get bmiColor {
    if (result >= 30) return Colors.red;
    if (result >= 25) return Colors.orange;
    if (result >= 18.5) return Colors.green;
    return Colors.blue;
  }
}
