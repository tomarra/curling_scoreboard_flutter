import 'dart:async';

import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:curling_scoreboard_flutter/src/version.dart';
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
        primarySwatch: Constants.primaryThemeColor,
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
  int totalEnds = Constants.defaultTotalEnds;
  String gameTime = '00:00:00';

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
      totalEnds = newTotalEnds;
    });
  }

  void enterScore(int score, String team) {
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

  void resetGame() {
    setState(() {
      redScores.clear();
      yellowScores.clear();
      currentEnd = 1;
      gameTime = '00:00:00';
      totalTimerSeconds = 0;
      ends.clear();
    });
  }

  void showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.resetDialogTitle),
          content: Text(AppLocalizations.of(context)!.resetDialogDescription),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.buttonLabelNo),
            ),
            ElevatedButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.buttonLabelYes),
            ),
          ],
        );
      },
    );
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        var settingsTotalEnds = totalEnds;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.settingsDialogTitle),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .settingsLabelNumberOfEnds,
                        ),
                        DropdownButton<int>(
                          value: settingsTotalEnds,
                          onChanged: (int? newValue) {
                            setState(() {
                              settingsTotalEnds = newValue!;
                            });
                          },
                          items: List.generate(10, (index) => index)
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value + 1,
                              child: Text((value + 1).toString()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .settingsLabelVersion(packageVersion),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    updateTotalEnds(settingsTotalEnds);
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.buttonLabelSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEnterScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var selectedTeam = AppLocalizations.of(context)!.teamNameRed;
        var selectedScore = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.enterScoreDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .enterScoreTeamDropdownLabel,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: selectedTeam,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTeam = newValue!;
                          });
                        },
                        items: <String>[
                          AppLocalizations.of(context)!.teamNameRed,
                          AppLocalizations.of(context)!.teamNameYellow,
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .enterScoreScoreDropdownLabel,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<int>(
                        value: selectedScore,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedScore = newValue!;
                          });
                        },
                        items: List.generate(9, (index) => index)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    enterScore(selectedScore, selectedTeam);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .enterScoreDialogSaveButtonLabel,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
        var selectedTeam = team;
        var selectedScore = score;
        final endText = (end > totalEnds)
            ? AppLocalizations.of(context)!.editScoreDialogExtraEndText
            : end.toString();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.editScoreDialogTitle(endText),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .editScoreTeamDropdownLabel,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: selectedTeam,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTeam = newValue!;
                          });
                        },
                        items: <String>[
                          AppLocalizations.of(context)!.teamNameRed,
                          AppLocalizations.of(context)!.teamNameYellow,
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .editScoreScoreDropdownLabel,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<int>(
                        value: selectedScore,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedScore = newValue!;
                          });
                        },
                        items: List.generate(9, (index) => index)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    editScore(end, selectedScore, selectedTeam);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .editScoreDialogSaveButtonLabel,
                  ),
                ),
              ],
            );
          },
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
          buildResetButton(context),
          buildAddScoreButton(context),
          buildSettingsButton(context),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildResetButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          showResetConfirmationDialog(context);
        },
        child: const Icon(Icons.replay_outlined),
      ),
    );
  }

  Widget buildAddScoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          showEnterScoreDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSettingsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          showSettingsDialog(context);
        },
        child: const Icon(Icons.settings),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Flexible(flex: 9, child: buildScoresRow()),
        Flexible(
          flex: 1,
          child: GameInfoRowWidget(
            end: (currentEnd > totalEnds)
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

  Widget buildScoresRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TeamTotalScoreWidget(
          score: redScores.fold(0, (a, b) => a + b).toString(),
          backgroundColor: Colors.red,
          teamName: AppLocalizations.of(context)!.teamNameRed,
        ),
        TeamTotalScoreWidget(
          score: yellowScores.fold(0, (a, b) => a + b).toString(),
          backgroundColor: Colors.yellow,
          teamName: AppLocalizations.of(context)!.teamNameYellow,
        ),
      ],
    );
  }

  Widget buildEndsContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final endContainerWidth = screenWidth / (totalEnds + 1);

    return Column(
      children: [
        Flexible(flex: 1, child: buildEndsRow(endContainerWidth)),
        Flexible(flex: 3, child: buildRedScoresRow(endContainerWidth)),
        Flexible(flex: 3, child: buildYellowScoresRow(endContainerWidth)),
      ],
    );
    ;
  }

  Widget buildEndsRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(totalEnds + 1, (index) => index + 1).map(
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
        color: Colors.blue,
      ),
      child: Text(
        (end > totalEnds)
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
        ...List.generate(totalEnds + 1, (index) {
          if (index < redScores.length) {
            return ScoreContainer(
              score: redScores[index],
              color: Colors.red,
              width: endContainerWidth,
            );
          } else {
            return ScoreContainer(
              score: -1,
              color: Colors.red[200]!,
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
        ...List.generate(totalEnds + 1, (index) {
          if (index < yellowScores.length) {
            return ScoreContainer(
              score: yellowScores[index],
              color: Colors.yellow,
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

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    required this.score,
    required this.color,
    required this.width,
    super.key,
  });

  final int score;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text(
        (score == -1) ? '' : score.toString(),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
