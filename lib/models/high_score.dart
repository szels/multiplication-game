import 'package:shared_preferences/shared_preferences.dart';
import 'difficulty.dart';

class HighScore {
  static String _getHighScoreKey(Difficulty difficulty) => 'high_score_${difficulty.name}';

  static Future<int> getHighScore(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_getHighScoreKey(difficulty)) ?? 0;
  }

  static Future<void> saveHighScore(Difficulty difficulty, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore(difficulty);
    
    if (score > currentHighScore) {
      await prefs.setInt(_getHighScoreKey(difficulty), score);
    }
  }
} 