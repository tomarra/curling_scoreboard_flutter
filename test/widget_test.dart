import 'package:curling_scoreboard_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Curling Scoreboard App', () {
    testWidgets('Initial state', (WidgetTester tester) async {
      await tester.pumpWidget(const CurlingScoreboardApp());

      // Verify that the app starts with the initial state
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Yellow'), findsOneWidget);
      expect(find.text('End 1'), findsOneWidget);
      expect(find.text('Game Time: 00:00'), findsOneWidget);
      expect(find.text('Scores'), findsNothing);
    });

    testWidgets('Enter Score', (WidgetTester tester) async {
      await tester.pumpWidget(const CurlingScoreboardApp());

      // Open the score dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Select 'Yellow' team and score of 3
      await tester.tap(find.text('Yellow'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      // Verify that the score is updated correctly
      expect(find.text('3'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('End 2'), findsOneWidget);
      expect(find.text('Game Time: 00:01'), findsOneWidget);
    });

    testWidgets('Reset Game', (WidgetTester tester) async {
      await tester.pumpWidget(const CurlingScoreboardApp());

      // Enter a score to make the game in progress
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      // Open the reset confirmation dialog
      await tester.tap(find.byIcon(Icons.replay_outlined));
      await tester.pumpAndSettle();

      // Cancel the reset
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Verify that the game state is not reset
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Yellow'), findsOneWidget);
      expect(find.text('End 2'), findsOneWidget);
      expect(find.text('Game Time: 00:01'), findsOneWidget);

      // Open the reset confirmation dialog again
      await tester.tap(find.byIcon(Icons.replay_outlined));
      await tester.pumpAndSettle();

      // Confirm the reset
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Verify that the game state is reset
      expect(find.text('Red'), findsNothing);
      expect(find.text('Yellow'), findsNothing);
      expect(find.text('End 1'), findsOneWidget);
      expect(find.text('Game Time: 00:00'), findsOneWidget);
    });
  });
}
