import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'difficulty.dart';
import 'user.dart';

class HighScore {
  static String _getHighScoreKey(Difficulty difficulty) => 'high_score_${difficulty.name}';
  static String _getTopScoresKey(Difficulty difficulty) => 'top_scores_${difficulty.name}';

  static Future<int> getHighScore(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_getHighScoreKey(difficulty)) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> getTopScores(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList(_getTopScoresKey(difficulty)) ?? [];
    return scoresJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList()
      ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
  }

  static Future<void> saveHighScore(Difficulty difficulty, int score, User user) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore(difficulty);
    
    if (score > currentHighScore) {
      await prefs.setInt(_getHighScoreKey(difficulty), score);
    }

    // Update top scores
    final scoresJson = prefs.getStringList(_getTopScoresKey(difficulty)) ?? [];
    final scores = scoresJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();

    // Add new score
    scores.add({
      'score': score,
      'user': user.toJson(),
    });

    // Sort by score (descending) and keep only top 10
    scores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    final topScores = scores.take(10).toList();

    // Save back to preferences
    await prefs.setStringList(
      _getTopScoresKey(difficulty),
      topScores.map((score) => jsonEncode(score)).toList(),
    );
  }
} 