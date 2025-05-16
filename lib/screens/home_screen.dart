import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../models/high_score.dart';

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
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(fontSize: 18),
              ),
            ),
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
} 