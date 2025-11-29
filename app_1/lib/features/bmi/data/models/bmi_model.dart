import 'package:app_1/features/bmi/domain/entities/bmi_entity.dart';

class BmiModel extends BmiEntity {
  const BmiModel({
    required super.result,
    required super.isMale,
    required super.age,
    required super.height,
    required super.weight,
  });

  // Convert from JSON
  factory BmiModel.fromJson(Map<String, dynamic> json) {
    return BmiModel(
      result: (json['result'] as num).toDouble(),
      isMale: json['isMale'] as bool,
      age: json['age'] as int,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }

  // Create from entity
  factory BmiModel.fromEntity(BmiEntity entity) {
    return BmiModel(
      result: entity.result,
      isMale: entity.isMale,
      age: entity.age,
      height: entity.height,
      weight: entity.weight,
    );
  }
}
