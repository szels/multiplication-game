import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/high_score.dart';
import '../models/difficulty.dart';
import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  
  const GameScreen({
    super.key,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _timeLeft = 60;
  int _num1 = 0;
  int _num2 = 0;
  int _correctAnswer = 0;
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
    _startTimer();
    _answerFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateNewProblem() {
    final random = Random();
    _num1 = random.nextInt(widget.difficulty.maxNumber) + 1;
    _num2 = random.nextInt(widget.difficulty.maxNumber) + 1;
    _correctAnswer = _num1 * _num2;
    _answerController.clear();
    _answerFocusNode.requestFocus();
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    if (userAnswer == _correctAnswer) {
      setState(() {
        _score++;
        _generateNewProblem();
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
    });
    HighScore.saveHighScore(widget.difficulty, _score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplication Game'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: _isGameOver
          ? _buildGameOverScreen()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Time Left: $_timeLeft seconds',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '$_num1 × $_num2 = ?',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _answerController,
                    focusNode: _answerFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                      hintText: 'Enter your answer',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _checkAnswer(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Your Score: $_score',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
} 