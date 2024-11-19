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

  late CurlingGame gameObject;
  int currentEnd = 1;

  Timer? timer;
  int totalTimerSeconds = 0;
  int overUnderInSeconds = 0;
  Duration fullGameDuration = Duration.zero;
  List<int> secondsPerEnd = [];

  @override
  void initState() {
    super.initState();

    gameObject = CurlingGame(
      team1: CurlingTeam(name: 'Red', color: Colors.red),
      team2: CurlingTeam(name: 'Yellow', color: Colors.yellow),
      numberOfEnds: 8,
      numberOfPlayersPerTeam: 4,
    );
    // Need a small delay to allow everything to be setup before showing
    // the start dialog.
    Timer.run(showGameStartDialog);
  }

  void showGameStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const GameStartDialog();
      },
    ).then((value) {
      gameObject = value as CurlingGame;
      startTimer();
    });
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
    fullGameDuration =
        Duration(minutes: gameObject.numberOfEnds * gameObject.minutesPerEnd);

    final secondsPerEnd = fullGameDuration.inSeconds ~/ gameObject.numberOfEnds;
    this.secondsPerEnd = List.generate(gameObject.numberOfEnds, (index) {
      return secondsPerEnd * (index + 1);
    });

    // Need to make sure we add in padding for the extra end
    this.secondsPerEnd.add(secondsPerEnd * (gameObject.numberOfEnds + 1));
  }

  void enterScore(CurlingEnd curlingEnd) {
    // Don't allow for entering scores if we have filled all the ends
    if (currentEnd > gameObject.numberOfEnds + 1) {
      return;
    }

    /*final newEnd = CurlingEnd(
      endNumber: currentEnd,
      team: team,
      score: score,
      gameTimeInSeconds: totalTimerSeconds,
    );*/

    setState(() {
      if (curlingEnd.scoringTeamName ==
          AppLocalizations.of(context)!.teamNameRed) {
        redScores.add(curlingEnd.score);
        yellowScores.add(0);
      } else {
        yellowScores.add(curlingEnd.score);
        redScores.add(0);
      }

      if (currentEnd + 1 <= gameObject.numberOfEnds + 1) {
        currentEnd++;
      }

      ends.add(curlingEnd);
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
        ..scoringTeamName = team
        ..score = score;

      ends[end - 1] = originalEndScore;
    });
  }

  void finishGame(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameEndDialog(
          ends: ends,
        );
      },
    ).then((value) {
      showGameStartDialog();
      setState(() {
        redScores.clear();
        yellowScores.clear();
        ends.clear();
        currentEnd = 1;
        totalTimerSeconds = 0;
        overUnderInSeconds = 0;

        timer!.cancel();
      });
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
      curlingEnd.gameTimeInSeconds = totalTimerSeconds;
      enterScore(curlingEnd);
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
          defaultTeam: ends[end - 1].scoringTeamName,
          defaultScore: ends[end - 1].score,
          end: end,
        );
      },
    ).then(
      (value) {
        final curlingEnd = value as CurlingEnd;
        editScore(
            curlingEnd.endNumber, curlingEnd.score, curlingEnd.scoringTeamName);
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
              if (ends.length < gameObject.numberOfEnds + 1) {
                showEnterScoreDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.addScoreGameCompleteMessage,
                    ),
                  ),
                );
              }
            },
          ),
          AppBarActionButton(
            icon: Icons.sports_score,
            label: AppLocalizations.of(context)!.buttonLabelFinishGame,
            onPressed: () {
              showFinishGameConfirmationDialog(context);
            },
          ),
          /*AppBarActionButton(
            icon: Icons.settings,
            onPressed: () {
              showSettingsDialog(context);
            },
          ),*/
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
            end: (currentEnd > gameObject.numberOfEnds)
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
            numberOfEnds: gameObject.numberOfEnds,
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
