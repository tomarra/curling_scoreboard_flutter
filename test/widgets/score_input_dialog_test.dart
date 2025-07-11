import 'package:curling_scoreboard_flutter/l10n/app_localizations.dart';
import 'package:curling_scoreboard_flutter/widgets/app_bar/score_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('ScoreInputDialog renders with score and team options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        const ScoreInputDialog(
          defaultTeam: 'Red',
          defaultScore: 0,
          end: 1,
        ),
      ),
    );
    // Check for dialog title
    expect(find.textContaining('End'), findsOneWidget);
    // Check for score options
    for (var i = 0; i <= 8; i++) {
      expect(find.text(i.toString()), findsWidgets);
    }
    // Check for team options
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Yellow '), findsOneWidget);
  });
}
