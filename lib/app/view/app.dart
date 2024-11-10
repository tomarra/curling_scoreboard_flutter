import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/l10n/l10n.dart';
import 'package:curling_scoreboard_flutter/scoreboard/scoreboard.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curling Scoreboard',
      theme: ScoreboardTheme.lightThemeData(context),
      darkTheme: ScoreboardTheme.darkThemeData(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ScoreboardPage(),
    );
  }
}

class ScoreboardTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      colorSchemeSeed: Constants.primaryThemeColor,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Colors.grey,
        shadowColor: Colors.blueGrey,
        elevation: 5,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      primarySwatch: Constants.primaryThemeColor,
      useMaterial3: true,
    );
  }
}
