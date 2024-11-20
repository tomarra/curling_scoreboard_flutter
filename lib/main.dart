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
  late CurlingGame gameObject;

  Timer? timer;
  int totalTimerSeconds = 0;
  int overUnderInSeconds = 0;
  Duration fullGameDuration = Duration.zero;
  List<int> secondsPerEnd = [];

  @override
  void initState() {
    super.initState();

    // Setup a dummy game object to start with, none of this is actually used
    // as we will be setting the game object in the game start dialog.
    gameObject = CurlingGame(
      team1: CurlingTeam(
        name: 'Red',
        color: Constants.redTeamColor,
        accentColor: Constants.redTeamAccentColor,
      ),
      team2: CurlingTeam(
        name: 'Yellow',
        color: Constants.yellowTeamColor,
        accentColor: Constants.yellowTeamAccentColor,
      ),
      numberOfEnds: Constants.defaultTotalEnds,
      numberOfPlayersPerTeam: Constants.defaultNumberOfPlayersPerTeam,
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
      overUnderInSeconds = Duration(
        seconds:
            totalTimerSeconds - secondsPerEnd[gameObject.currentPlayingEnd - 1],
      ).inSeconds;
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
    if (gameObject.currentPlayingEnd > gameObject.numberOfEnds + 1) {
      return;
    }

    setState(() {
      if (gameObject.currentPlayingEnd + 1 <= gameObject.numberOfEnds + 1) {
        gameObject.currentPlayingEnd++;
      }

      final currentEndList = gameObject.ends.toList()..add(curlingEnd);
      gameObject.ends = currentEndList;
    });
  }

  void editScore(int end, int score, String team) {
    final originalEndScore = gameObject.ends.elementAt(end - 1);

    setState(() {
      originalEndScore
        ..scoringTeamName = team
        ..score = score;

      gameObject.ends[end - 1] = originalEndScore;
    });
  }

  void finishGame(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameEndDialog(
          ends: gameObject.ends,
        );
      },
    ).then((value) {
      showGameStartDialog();
      setState(() {
        gameObject.ends.clear();
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
          end: gameObject.currentPlayingEnd,
        );
      },
    ).then((value) {
      // Need to add in the current timer value to the end so we get it at the
      // point of entry on the dialog, not when the dialog came up
      final curlingEnd = value as CurlingEnd
        ..gameTimeInSeconds = totalTimerSeconds;

      enterScore(curlingEnd);
    });
  }

  void showEditScoreDialog(int end) {
    if (end > gameObject.currentPlayingEnd) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScoreInputDialog(
          defaultTeam: gameObject.ends[end - 1].scoringTeamName,
          defaultScore: gameObject.ends[end - 1].score,
          end: end,
        );
      },
    ).then(
      (value) {
        final curlingEnd = value as CurlingEnd;
        editScore(
          curlingEnd.endNumber,
          curlingEnd.score,
          curlingEnd.scoringTeamName,
        );
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
            label: AppLocalizations.of(context)!.appBarAddScoreButtonLabel,
            onPressed: () {
              if (gameObject.ends.length < gameObject.numberOfEnds + 1) {
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
            label: AppLocalizations.of(context)!.appBarFinishGameButtonLabel,
            onPressed: () {
              showFinishGameConfirmationDialog(context);
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
            team1Score: gameObject.team1TotalScore,
            team1Color: gameObject.team1.color,
            team2Score: gameObject.team2TotalScore,
            team2Color: gameObject.team2.color,
            endNumber: gameObject.currentPlayingEnd,
          ),
        ),
        Flexible(
          child: GameInfoRowWidget(
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
            team1Scores: gameObject.team1ScoresByEnd,
            team2Scores: gameObject.team2ScoresByEnd,
            team1EmptyColor: gameObject.team1.accentColor,
            team2EmptyColor: gameObject.team2.accentColor,
            team1FilledColor: gameObject.team1.color,
            team2FilledColor: gameObject.team2.color,
            onPressed: showEditScoreDialog,
          ),
        ),
      ],
    );
  }
}
