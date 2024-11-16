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

  int currentEnd = Constants.defaultStartingEnd;
  String gameTime = Constants.defaultGameTime;

  ScoreboardSettings settings = ScoreboardSettings();

  Timer? timer;
  int totalTimerSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalTimerSeconds += 1;
      setState(updateGameTimeString);
    });
  }

  void updateGameTimeString() {
    final duration = Duration(seconds: totalTimerSeconds);

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    gameTime =
        '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void updateTotalEnds(int newTotalEnds) {
    setState(() {
      settings.numberOfEnds = newTotalEnds;
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

  void showEditScoreDialog({
    required BuildContext context,
    required int end,
    required String team,
    required int score,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScoreInputDialog(
          defaultTeam: team,
          defaultScore: score,
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
            redScore: redScores.fold(0, (a, b) => a + b),
            yellowScore: yellowScores.fold(0, (a, b) => a + b),
          ),
        ),
        Flexible(
          child: GameInfoRowWidget(
            end: (currentEnd > settings.numberOfEnds)
                ? AppLocalizations.of(context)!.gameInfoExtraEndText
                : currentEnd.toString(),
            gameTime: gameTime,
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: buildEndsContainer(),
        ),
      ],
    );
  }

  Widget buildEndsContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final endContainerWidth = screenWidth / (settings.numberOfEnds + 1);

    return Column(
      children: [
        Flexible(child: buildEndsRow(endContainerWidth)),
        Flexible(flex: 3, child: buildRedScoresRow(endContainerWidth)),
        Flexible(flex: 3, child: buildYellowScoresRow(endContainerWidth)),
      ],
    );
  }

  Widget buildEndsRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(settings.numberOfEnds + 1, (index) => index + 1).map(
          (end) => InkWell(
            child: buildEndContainer(end, endContainerWidth),
            onTap: () {
              if (ends.length >= end) {
                showEditScoreDialog(
                  context: context,
                  end: end,
                  team: ends[end - 1].team,
                  score: ends[end - 1].score,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildEndContainer(int end, double width) {
    return Container(
      alignment: Alignment.center,
      width: width,
      decoration: const BoxDecoration(
        color: Constants.primaryThemeColor,
      ),
      child: Text(
        (end > settings.numberOfEnds)
            ? AppLocalizations.of(context)!.scoreboardExtraEndLabel
            : end.toString(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildRedScoresRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(settings.numberOfEnds + 1, (index) {
          if (index < redScores.length) {
            return ScoreContainer(
              score: redScores[index],
              color: Constants.redTeamColor,
              width: endContainerWidth,
            );
          } else {
            return ScoreContainer(
              score: -1,
              color: Constants.redTeamAccentColor,
              width: endContainerWidth,
            );
          }
        }),
      ],
    );
  }

  Widget buildYellowScoresRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(settings.numberOfEnds + 1, (index) {
          if (index < yellowScores.length) {
            return ScoreContainer(
              score: yellowScores[index],
              color: Constants.yellowTeamColor,
              width: endContainerWidth,
            );
          } else {
            return ScoreContainer(
              score: -1,
              color: Constants.yellowTeamAccentColor,
              width: endContainerWidth,
            );
          }
        }),
      ],
    );
  }
}
