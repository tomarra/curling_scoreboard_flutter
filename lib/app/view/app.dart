import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/l10n/l10n.dart';
import 'package:curling_scoreboard_flutter/scoreboard/scoreboard.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Curling Scoreboard",
      theme: ThemeData(
        primarySwatch: Constants.primaryThemeColor,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ScoreboardPage(),
    );
  }
}
