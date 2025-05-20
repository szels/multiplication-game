import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multiplication_game/providers/theme_provider.dart';
import 'package:multiplication_game/screens/home_screen.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        home: HomeScreen(),
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
} 