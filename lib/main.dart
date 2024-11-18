import 'dart:async';

import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:curling_scoreboard_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const CurlingScoreboardApp());
}

class CurlingScoreboardApp extends StatelessWidget {
  const CurlingScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curling Scoreboard',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorSchemeSeed: Constants.primaryThemeColor,
        useMaterial3: true,
      ),
      home: const CurlingScoreboardScreen(),
    );
  }
}

class CurlingScoreboardScreen extends StatefulWidget {
  const CurlingScoreboardScreen({super.key});

  @override
  State<CurlingScoreboardScreen> createState() =>
      _CurlingScoreboardScreenState();
}

class _CurlingScoreboardScreenState extends State<CurlingScoreboardScreen> {
  List<int> redScores = [];
  List<int> yellowScores = [];
  List<CurlingEnd> ends = [];

  ScoreboardSettings settings = ScoreboardSettings();

  int currentEnd = Constants.defaultStartingEnd;
  String gameTime = Constants.defaultGameTime;
  String gameTimeOverUnder = '';

  Timer? timer;
  int totalTimerSeconds = 0;
  int overUnderInSeconds = 0;
  Duration fullGameDuration = Duration.zero;
  List<int> secondsPerEnd = [];

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalTimerSeconds += 1;
      overUnderInSeconds =
          Duration(seconds: totalTimerSeconds - secondsPerEnd[currentEnd - 1])
              .inSeconds;
      setState(() {});
    });

    calculateSecondsPerEnd();
  }

  void calculateSecondsPerEnd() {
    fullGameDuration = Duration(minutes: settings.numberOfEnds * 15);

    final secondsPerEnd = fullGameDuration.inSeconds ~/ settings.numberOfEnds;
    this.secondsPerEnd = List.generate(settings.numberOfEnds, (index) {
      return secondsPerEnd * (index + 1);
    });
  }

  void enterScore(int score, String team) {
    // Don't allow for entering scores if we have filled all the ends
    if (currentEnd - 1 >= settings.numberOfEnds + 1) {
      return;
    }

    final newEnd = CurlingEnd(
      endNumber: currentEnd,
      team: team,
      score: score,
      gameTimeInSeconds: totalTimerSeconds,
    );

    setState(() {
      if (team == AppLocalizations.of(context)!.teamNameRed) {
        redScores.add(score);
        yellowScores.add(0);
      } else {
        yellowScores.add(score);
        redScores.add(0);
      }
      currentEnd++;

      ends.add(newEnd);
    });
  }

  void editScore(int end, int score, String team) {
    final originalEndScore = ends.elementAt(end - 1);

    setState(() {
      if (team == AppLocalizations.of(context)!.teamNameRed) {
        redScores[end - 1] = score;
        yellowScores[end - 1] = 0;
      } else {
        yellowScores[end - 1] = score;
        redScores[end - 1] = 0;
      }

      originalEndScore
        ..team = team
        ..score = score;

      ends[end - 1] = originalEndScore;
    });
  }

  void finishGame() {
    setState(() {
      redScores.clear();
      yellowScores.clear();
      currentEnd = Constants.defaultStartingEnd;
      gameTime = Constants.defaultGameTime;
      totalTimerSeconds = 0;
      ends.clear();
    });
  }

  void showFinishGameConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FinishGameDialog(
          finishGameAction: finishGame,
        );
      },
    );
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingsDialog(
          settings: settings,
        );
      },
    ).then((value) {
      settings = value as ScoreboardSettings;
      calculateSecondsPerEnd();
    });
  }

  void showEnterScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScoreInputDialog(
          defaultTeam: 'Red',
          defaultScore: 0,
          end: currentEnd,
        );
      },
    ).then((value) {
      final curlingEnd = value as CurlingEnd;
      enterScore(curlingEnd.score, curlingEnd.team);
    });
  }

  void showEditScoreDialog(int end) {
    if (end > currentEnd) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScoreInputDialog(
          defaultTeam: ends[end - 1].team,
          defaultScore: ends[end - 1].score,
          end: end,
        );
      },
    ).then(
      (value) {
        final curlingEnd = value as CurlingEnd;
        editScore(curlingEnd.endNumber, curlingEnd.score, curlingEnd.team);
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(AppLocalizations.of(context)!.appBarTitle),
        actions: <Widget>[
          AppBarActionButton(
            icon: Icons.add,
            label: AppLocalizations.of(context)!.buttonLabelAddScore,
            onPressed: () {
              showEnterScoreDialog(context);
            },
          ),
          AppBarActionButton(
            icon: Icons.sports_score,
            label: AppLocalizations.of(context)!.buttonLabelFinishGame,
            onPressed: () {
              showFinishGameConfirmationDialog(context);
            },
          ),
          AppBarActionButton(
            icon: Icons.settings,
            onPressed: () {
              showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Flexible(
          flex: 9,
          child: TotalScoreRow(
            team1Score: redScores.fold(0, (a, b) => a + b),
            team1Color: Constants.redTeamColor,
            team2Score: yellowScores.fold(0, (a, b) => a + b),
            team2Color: Constants.yellowTeamColor,
            endNumber: currentEnd,
          ),
        ),
        Flexible(
          child: GameInfoRowWidget(
            end: (currentEnd > settings.numberOfEnds)
                ? AppLocalizations.of(context)!.gameInfoExtraEndText
                : currentEnd.toString(),
            gameTime: Duration(seconds: totalTimerSeconds),
            gameTimeOverUnder: Duration(seconds: overUnderInSeconds),
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: ScoreboardBaseballLayout(
            numberOfEnds: settings.numberOfEnds,
            endsContainerColor: Constants.primaryThemeColor,
            team1Scores: redScores,
            team2Scores: yellowScores,
            team1EmptyColor: Constants.redTeamAccentColor,
            team2EmptyColor: Constants.yellowTeamAccentColor,
            team1FilledColor: Constants.redTeamColor,
            team2FilledColor: Constants.yellowTeamColor,
            onPressed: showEditScoreDialog,
          ),
        ),
      ],
    );
  }
}
