import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MultiplicationGame());
}

class MultiplicationGame extends StatelessWidget {
  const MultiplicationGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiplication Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
} 