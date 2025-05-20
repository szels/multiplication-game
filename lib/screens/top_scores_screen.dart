import 'package:flutter/material.dart';
import '../models/high_score.dart';
import '../models/difficulty.dart';
import '../models/user.dart';

class TopScoresScreen extends StatelessWidget {
  const TopScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Scores'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: Difficulty.values.length,
        child: Column(
          children: [
            TabBar(
              tabs: Difficulty.values.map((difficulty) => Tab(
                text: difficulty.label,
              )).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: Difficulty.values.map((difficulty) => _TopScoresList(difficulty: difficulty)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopScoresList extends StatelessWidget {
  final Difficulty difficulty;

  const _TopScoresList({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: HighScore.getTopScores(difficulty),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No scores yet for ${difficulty.label}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final score = snapshot.data![index];
            final user = User.fromJson(score['user'] as Map<String, dynamic>);
            final date = user.timestamp;
            
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(user.username),
              subtitle: Text(
                '${date.day}/${date.month}/${date.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                '${score['score']}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _getDifficultyColor(difficulty),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
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