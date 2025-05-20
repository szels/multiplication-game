import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiplication_game/models/difficulty.dart';
import 'package:multiplication_game/models/high_score.dart';
import 'package:multiplication_game/models/user.dart';
import 'package:multiplication_game/providers/theme_provider.dart';
import 'package:multiplication_game/screens/game_screen.dart';
import 'package:multiplication_game/screens/home_screen.dart';
import 'package:multiplication_game/screens/top_scores_screen.dart';
import 'test_helper.dart';

void main() {
  group('User System Tests', () {
    testWidgets('Username validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Try to start game without username
      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();
      
      // Should show snackbar
      expect(find.text('Please enter your username'), findsOneWidget);
      
      // Enter username and try again
      await tester.enterText(find.byType(TextField), 'TestUser');
      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();
      
      // Should navigate to game screen
      expect(find.byType(GameScreen), findsOneWidget);
    });
  });

  group('Game Mechanics Tests', () {
    testWidgets('Game timer works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Enter username and start game
      await tester.enterText(find.byType(TextField), 'TestUser');
      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();
      
      // Wait for 61 seconds
      await tester.pump(const Duration(seconds: 61));
      
      // Should show game over screen
      expect(find.text('Game Over!'), findsOneWidget);
    });

    testWidgets('Score tracking works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      // Enter username and start game
      await tester.enterText(find.byType(TextField).first, 'TestUser');
      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();
      // Get initial score
      final scoreText = find.textContaining('Score:').first;
      final initialScore = int.parse(
        (scoreText.evaluate().single.widget as Text).data!.split('Score: ')[1]
      );
      // Get the problem text
      final problemText = find.textContaining('=').first;
      final problemString = (problemText.evaluate().single.widget as Text).data!;
      final numbers = problemString.split('=')[0].trim().split('×');
      final num1 = int.parse(numbers[0].trim());
      final num2 = int.parse(numbers[1].trim());
      final answer = num1 * num2;
      // Enter answer in the only TextField (answer field)
      await tester.enterText(find.byType(TextField), answer.toString());
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pumpAndSettle();
      // Score should increase
      expect(find.textContaining('Score: ${initialScore + 1}'), findsOneWidget);
    });
  });

  group('Difficulty Level Tests', () {
    testWidgets('Difficulty levels are correctly displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Check all difficulty buttons exist
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);
      
      // Check colors
      final easyButton = tester.widget<ElevatedButton>(find.ancestor(
        of: find.text('Easy'),
        matching: find.byType(ElevatedButton),
      ).first);
      final mediumButton = tester.widget<ElevatedButton>(find.ancestor(
        of: find.text('Medium'),
        matching: find.byType(ElevatedButton),
      ).first);
      final hardButton = tester.widget<ElevatedButton>(find.ancestor(
        of: find.text('Hard'),
        matching: find.byType(ElevatedButton),
      ).first);
      
      expect(easyButton.style?.backgroundColor?.resolve({}), Colors.green);
      expect(mediumButton.style?.backgroundColor?.resolve({}), Colors.orange);
      expect(hardButton.style?.backgroundColor?.resolve({}), Colors.red);
    });

    testWidgets('Difficulty affects number range', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Test each difficulty
      for (var difficulty in Difficulty.values) {
        await tester.enterText(find.byType(TextField), 'TestUser');
        await tester.tap(find.text(difficulty.label));
        await tester.pumpAndSettle();
        
        // Get problem numbers
        final problemText = find.textContaining('=').first;
        final problemString = (problemText.evaluate().single.widget as Text).data!;
        final numbers = problemString.split('=')[0].trim().split('×');
        final num1 = int.parse(numbers[0].trim());
        final num2 = int.parse(numbers[1].trim());
        
        // Check numbers are within range
        expect(num1, lessThanOrEqualTo(difficulty.maxNumber));
        expect(num2, lessThanOrEqualTo(difficulty.maxNumber));
        
        // Go back to home screen
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }
    });
  });

  group('High Score System Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('High scores are saved correctly', () async {
      const username = 'TestUser';
      const score = 10;
      
      // Save high score
      await HighScore.saveHighScore(
        Difficulty.easy,
        score,
        User(username: username),
      );
      
      // Get high score
      final savedScore = await HighScore.getHighScore(Difficulty.easy);
      expect(savedScore, score);
    });

    testWidgets('High scores are displayed correctly', (WidgetTester tester) async {
      // Save a high score first
      await HighScore.saveHighScore(
        Difficulty.easy,
        10,
        User(username: 'TestUser'),
      );
      
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      
      // Check high score is displayed
      expect(find.textContaining('High Score: 10'), findsOneWidget);
    });
  });

  group('Top Scores Screen Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Top scores screen displays correctly', (WidgetTester tester) async {
      // Save some test scores
      for (var i = 0; i < 3; i++) {
        await HighScore.saveHighScore(
          Difficulty.easy,
          10 - i,
          User(username: 'TestUser$i'),
        );
      }
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: 1000, // Ensure enough space for scrolling
                child: const TestApp(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Scroll to the button if needed
      await tester.dragUntilVisible(
        find.text('View Top Scores'),
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      
      // Navigate to top scores
      await tester.tap(find.text('View Top Scores'));
      await tester.pumpAndSettle();
      
      // Check scores are displayed
      expect(find.text('TestUser0'), findsOneWidget);
      expect(find.text('TestUser1'), findsOneWidget);
      expect(find.text('TestUser2'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('Theme toggle works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      // Find and tap the theme toggle button (either icon)
      Finder themeButton = find.byIcon(Icons.dark_mode);
      bool wasDark = false;
      if (tester.any(themeButton)) {
        await tester.tap(themeButton);
        wasDark = true;
      } else {
        themeButton = find.byIcon(Icons.light_mode);
        expect(themeButton, findsOneWidget);
        await tester.tap(themeButton);
      }
      await tester.pumpAndSettle();
      // Check that the icon changed
      if (wasDark) {
        expect(find.byIcon(Icons.light_mode), findsOneWidget);
      } else {
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      }
    });
  });

  group('UI Tests', () {
    testWidgets('Username input field has correct width', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      final textField = tester.widget<TextField>(find.byType(TextField));
      final parent = tester.widget<SizedBox>(find.ancestor(
        of: find.byType(TextField),
        matching: find.byType(SizedBox),
      ).first);
      
      expect(parent.width, 500);
    });

    testWidgets('View Top Scores button is centered', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());
      
      final button = find.text('View Top Scores');
      final centerAncestors = find.ancestor(
        of: button,
        matching: find.byType(Center),
      ).evaluate();
      
      expect(centerAncestors.length, greaterThanOrEqualTo(1));
    });
  });
} 