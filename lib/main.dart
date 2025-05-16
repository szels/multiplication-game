import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MultiplicationGame(),
    ),
  );
}

class MultiplicationGame extends StatelessWidget {
  const MultiplicationGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Multiplication Game',
          theme: themeProvider.theme,
          home: const HomeScreen(),
        );
      },
    );
  }
} 