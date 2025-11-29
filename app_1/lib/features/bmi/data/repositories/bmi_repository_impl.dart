import 'package:app_1/features/bmi/data/models/bmi_model.dart';
import 'package:app_1/features/bmi/domain/entities/bmi_entity.dart';
import 'package:app_1/features/bmi/domain/repositories/bmi_repository.dart';
// import 'package:flutter/material.dart';

class BmiRepositoryImpl implements BmiRepository {
  @override
  BmiEntity calculateBmi({
    required double height,
    required double weight,
    required bool isMale,
    required int age,
  }) {
    // Convert height from cm to meters
    final heightInMeters = height / 100;
    // Calculate BMI: weight (kg) / (height (m) ^ 2)
    final bmi = weight / (heightInMeters * heightInMeters);

    return BmiModel(
      result: bmi,
      isMale: isMale,
      age: age,
      height: height,
      weight: weight,
    );
  }

  @override
  String getBmiCategory(double bmiResult) {
    if (bmiResult >= 30) return 'Obesity';
    if (bmiResult >= 25) return 'Overweight';
    if (bmiResult >= 18.5) return 'Normal';
    return 'Underweight';
  }

  @override
  String getBmiColor(double bmiResult) {
    if (bmiResult >= 30) return 'red';
    if (bmiResult >= 25) return 'orange';
    if (bmiResult >= 18.5) return 'green';
    return 'blue';
  }
}
