import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../data/repositories/bmi_repository_impl.dart';
import '../../domain/repositories/bmi_repository.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMale = true;
  double height = 170;
  int weight = 70;
  int age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Body Mass Index Calculator',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Column(
        children: [
          // Gender Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildGenderCard('Male', Icons.male, isMale, () {
                    setState(() => isMale = true);
                  }),
                  const SizedBox(width: 16),
                  _buildGenderCard('Female', Icons.female, !isMale, () {
                    setState(() => isMale = false);
                  }),
                ],
              ),
            ),
          ),

          // Height Slider
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  'HEIGHT',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${height.round()}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const Text(
                      'cm',
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.teal,
                    inactiveTrackColor: Colors.white,
                    trackHeight: 4.0,
                    thumbColor: Colors.teal,
                    overlayColor: Colors.teal.withValues(alpha: 0.3),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12.0,
                      elevation: 4.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20.0,
                    ),
                  ),
                  child: Slider(
                    value: height,
                    min: 120,
                    max: 220,
                    divisions: 100,
                    onChanged: (value) {
                      setState(() => height = value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Weight and Age
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildNumberCard(
                    'WEIGHT',
                    weight,
                    onIncrement: () => setState(() => weight++),
                    onDecrement: () => setState(() => weight--),
                  ),
                  const SizedBox(width: 16),
                  _buildNumberCard(
                    'AGE',
                    age,
                    onIncrement: () => setState(() => age++),
                    onDecrement: () => setState(() => age--),
                  ),
                ],
              ),
            ),
          ),

          // Calculate Button
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
                onPressed: () {
                  final bmiRepository = context.read<BmiRepository>();
                  final bmiEntity = bmiRepository.calculateBmi(
                    height: height,
                    weight: weight.toDouble(),
                    isMale: isMale,
                    age: age,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(bmiEntity: bmiEntity),
                    ),
                  );
                },
                child: const Text(
                  'CALCULATE',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(
    String gender,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberCard(
    String title,
    int value, {
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.teal),
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  heroTag: '${title}_decrement',
                  onPressed: onDecrement,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.small(
                  heroTag: '${title}_increment',
                  onPressed: onIncrement,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
