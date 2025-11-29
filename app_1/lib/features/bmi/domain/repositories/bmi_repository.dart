import 'package:app_1/features/bmi/domain/entities/bmi_entity.dart';

abstract class BmiRepository {
  /// Calculates BMI based on weight and height
  /// Returns BmiEntity with the calculated result
  BmiEntity calculateBmi({
    required double height,
    required double weight,
    required bool isMale,
    required int age,
  });

  /// Gets BMI category based on the calculated result
  String getBmiCategory(double bmiResult);

  /// Gets color representation for the BMI result
  String getBmiColor(double bmiResult);
}
