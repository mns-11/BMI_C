import 'package:flutter/material.dart';
import 'package:app_1/features/bmi/domain/entities/bmi_entity.dart';

class ResultPage extends StatelessWidget {
  final BmiEntity bmiEntity;

  const ResultPage({super.key, required this.bmiEntity});

  // Calculate ideal weight range based on BMI formula
  String _calculateIdealWeightRange(double height) {
    // Convert height from cm to meters
    final heightInMeters = height / 100;

    // Calculate weight range for BMI between 18.5 and 24.9
    final minWeight = 18.5 * (heightInMeters * heightInMeters);
    final maxWeight = 24.9 * (heightInMeters * heightInMeters);

    return '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg';
  }

  String _getBmiInterpretation(double bmi) {
    if (bmi >= 30) {
      return 'You have a higher than normal body weight. Try to exercise more and maintain a healthy diet.';
    } else if (bmi >= 25) {
      return 'You have a higher than normal body weight. Try to exercise more.';
    } else if (bmi >= 18.5) {
      return 'You have a normal body weight. Good job!';
    } else {
      return 'You have a lower than normal body weight. You can eat a bit more.';
    }
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        height: 140, // Slightly increased height to accommodate text
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              // ✅ FIX: Corrected BoxShadow color creation
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Result',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // SizedBox(height: 10),
          // BMI Result
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  // ✅ FIX: Changed to MainAxisAlignment.start to prevent overflow caused by spaceEvenly
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ), // Added SizedBox for controlled spacing
                    Text(
                      bmiEntity.bmiCategory.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bmiEntity.result.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current Weight: ${bmiEntity.weight.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 18, color: Colors.teal),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'IDEAL WEIGHT RANGE',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _calculateIdealWeightRange(bmiEntity.height),
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _getBmiInterpretation(bmiEntity.result),
                      textAlign: TextAlign.center,
                      // ✅ FIX: Reduced font size slightly to prevent overflow on interpretation text
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          // User Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // Gender and Age
                Row(
                  children: [
                    _buildInfoCard(
                      'GENDER',
                      bmiEntity.isMale ? 'Male' : 'Female',
                      bmiEntity.isMale ? Icons.male : Icons.female,
                      bmiEntity.isMale ? Colors.blue : Colors.pink,
                    ),
                    const SizedBox(width: 10),
                    _buildInfoCard(
                      'AGE',
                      '${bmiEntity.age} years',
                      Icons.calendar_today,
                      Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Height and Weight
                Row(
                  children: [
                    _buildInfoCard(
                      'HEIGHT',
                      '${bmiEntity.height.toStringAsFixed(1)} cm',
                      Icons.height,
                      Colors.teal,
                    ),
                    const SizedBox(width: 10),
                    _buildInfoCard(
                      'WEIGHT',
                      '${bmiEntity.weight.toStringAsFixed(1)} kg',
                      Icons.monitor_weight,
                      Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Recalculate Button
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'RE-CALCULATE',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
