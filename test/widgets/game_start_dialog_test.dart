import 'package:curling_scoreboard_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  /*testWidgets('GameStartDialog renders and allows selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrapWithMaterialApp(const GameStartDialog()));

    // Check for title
    expect(find.text('Game Setup'), findsOneWidget);
    // Check for number of ends options
    expect(find.text('2'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    // Check for players per team options
    expect(find.text('0'), findsOneWidget);
    expect(find.text('2'), findsWidgets); // 2 appears in both ends and players
    expect(find.text('4'), findsWidgets);
    // Check for hammer options
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Yellow '), findsOneWidget);
  });*/
}
