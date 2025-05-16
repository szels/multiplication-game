import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../models/high_score.dart';
import '../models/difficulty.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplication Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Multiplication Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Solve as many multiplication problems\nas you can in 1 minute!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Text(
              'Select Difficulty:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...Difficulty.values.map((difficulty) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(difficulty: difficulty),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: _getDifficultyColor(difficulty),
                ),
                child: Text(
                  difficulty.label,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )).toList(),
            const SizedBox(height: 20),
            FutureBuilder<int>(
              future: HighScore.getHighScore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'High Score: ${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text('No high score yet');
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }
} 