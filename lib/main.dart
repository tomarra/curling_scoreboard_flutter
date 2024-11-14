import 'dart:async';

import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:curling_scoreboard_flutter/src/version.dart';
import 'package:curling_scoreboard_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

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
  int totalEnds = Constants.defaultTotalEnds;
  String gameTime = Constants.defaultGameTime;

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
    // Don't allow for entering scores if we have filled all the ends
    if (currentEnd - 1 >= totalEnds + 1) {
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
        return AlertDialog(
          content: Text(
            AppLocalizations.of(context)!.finishGameDialogDescription,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentPadding: const EdgeInsets.all(50),
          actionsAlignment: MainAxisAlignment.center,
          buttonPadding: const EdgeInsets.all(200),
          actions: [
            ElevatedButton(
              onPressed: () {
                finishGame();
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.buttonLabelYes,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.buttonLabelNo,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  child: Text(
                    AppLocalizations.of(context)!.buttonLabelSave,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        var currentTeamSelectedIndex = 0;
        var currentScoreSelectedIndex = 0;
        var selectedScore = 0;

        final teamNames = {
          0: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: EnterEditScoreDialogTeamText(
              team: AppLocalizations.of(context)!.teamNameRed,
            ),
          ),
          1: EnterEditScoreDialogTeamText(
            team: AppLocalizations.of(context)!.teamNameYellow,
          ),
        };

        final scoreItems = {
          0: const Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: EnterEditScoreDialogScoreText(score: '0'),
          ),
          1: const EnterEditScoreDialogScoreText(score: '1'),
          2: const EnterEditScoreDialogScoreText(score: '2'),
          3: const EnterEditScoreDialogScoreText(score: '3'),
          4: const EnterEditScoreDialogScoreText(score: '4'),
          5: const EnterEditScoreDialogScoreText(score: '5'),
          6: const EnterEditScoreDialogScoreText(score: '6'),
          7: const EnterEditScoreDialogScoreText(score: '7'),
          8: const EnterEditScoreDialogScoreText(score: '8'),
        };

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.enterScoreDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialSegmentedControl(
                    children: scoreItems,
                    selectionIndex: currentScoreSelectedIndex,
                    borderColor: Colors.grey,
                    selectedColor: Colors.blueAccent,
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(color: Colors.black),
                    borderWidth: 1,
                    borderRadius: 20,
                    horizontalPadding: const EdgeInsets.all(10),
                    verticalOffset: 25,
                    onSegmentTapped: (index) {
                      setState(() {
                        currentScoreSelectedIndex = index;

                        selectedScore = index;
                      });
                    },
                  ),
                  MaterialSegmentedControl(
                    children: teamNames,
                    selectionIndex: currentTeamSelectedIndex,
                    borderColor: Colors.grey,
                    selectedColor: currentTeamSelectedIndex == 0
                        ? Constants.redTeamColor
                        : Constants.yellowTeamColor,
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(color: Colors.black),
                    borderWidth: 1,
                    borderRadius: 20,
                    horizontalPadding: const EdgeInsets.all(10),
                    verticalOffset: 25,
                    onSegmentTapped: (index) {
                      setState(() {
                        currentTeamSelectedIndex = index;

                        index == 0
                            ? selectedTeam =
                                AppLocalizations.of(context)!.teamNameRed
                            : selectedTeam =
                                AppLocalizations.of(context)!.teamNameYellow;
                      });
                    },
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
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
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
        var currentTeamSelectedIndex =
            team == AppLocalizations.of(context)!.teamNameRed ? 0 : 1;
        var currentScoreSelectedIndex = score;
        var selectedScore = score;

        final teamNames = {
          0: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: EnterEditScoreDialogTeamText(
              team: AppLocalizations.of(context)!.teamNameRed,
            ),
          ),
          1: EnterEditScoreDialogTeamText(
            team: AppLocalizations.of(context)!.teamNameYellow,
          ),
        };

        final scoreItems = {
          0: const Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: EnterEditScoreDialogScoreText(score: '0'),
          ),
          1: const EnterEditScoreDialogScoreText(score: '1'),
          2: const EnterEditScoreDialogScoreText(score: '2'),
          3: const EnterEditScoreDialogScoreText(score: '3'),
          4: const EnterEditScoreDialogScoreText(score: '4'),
          5: const EnterEditScoreDialogScoreText(score: '5'),
          6: const EnterEditScoreDialogScoreText(score: '6'),
          7: const EnterEditScoreDialogScoreText(score: '7'),
          8: const EnterEditScoreDialogScoreText(score: '8'),
        };

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.editScoreDialogTitle(
                  end.toString(),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialSegmentedControl(
                    children: scoreItems,
                    selectionIndex: currentScoreSelectedIndex,
                    borderColor: Colors.grey,
                    selectedColor: Colors.blueAccent,
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(color: Colors.black),
                    borderWidth: 1,
                    borderRadius: 20,
                    horizontalPadding: const EdgeInsets.all(10),
                    verticalOffset: 25,
                    onSegmentTapped: (index) {
                      setState(() {
                        currentScoreSelectedIndex = index;

                        selectedScore = index;
                      });
                    },
                  ),
                  MaterialSegmentedControl(
                    children: teamNames,
                    selectionIndex: currentTeamSelectedIndex,
                    borderColor: Colors.grey,
                    selectedColor: currentTeamSelectedIndex == 0
                        ? Constants.redTeamColor
                        : Constants.yellowTeamColor,
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(color: Colors.black),
                    borderWidth: 1,
                    borderRadius: 20,
                    horizontalPadding: const EdgeInsets.all(10),
                    verticalOffset: 25,
                    onSegmentTapped: (index) {
                      setState(() {
                        currentTeamSelectedIndex = index;

                        index == 0
                            ? selectedTeam =
                                AppLocalizations.of(context)!.teamNameRed
                            : selectedTeam =
                                AppLocalizations.of(context)!.teamNameYellow;
                      });
                    },
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
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
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
          buildAddScoreButton(context),
          buildFinishGameButton(context),
          buildSettingsButton(context),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildFinishGameButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ElevatedButton(
        onPressed: () {
          showFinishGameConfirmationDialog(context);
        },
        child: Row(
          children: [
            const Icon(
              Icons.sports_score,
            ),
            const SizedBox(width: 10),
            FittedBox(
              child: Text(
                AppLocalizations.of(context)!.buttonLabelFinishGame,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddScoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ElevatedButton(
        onPressed: () {
          showEnterScoreDialog(context);
        },
        child: Row(
          children: [
            const Icon(
              Icons.add,
            ),
            const SizedBox(width: 10),
            FittedBox(
              child: Text(
                AppLocalizations.of(context)!.buttonLabelAddScore,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          showSettingsDialog(context);
        },
        child: const Icon(
          Icons.settings,
          size: 40,
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Flexible(flex: 9, child: buildScoresRow()),
        Flexible(
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
          backgroundColor: Constants.redTeamColor,
          teamName: AppLocalizations.of(context)!.teamNameRed,
        ),
        TeamTotalScoreWidget(
          score: yellowScores.fold(0, (a, b) => a + b).toString(),
          backgroundColor: Constants.yellowTeamColor,
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
        color: Constants.primaryThemeColor,
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
        ...List.generate(totalEnds + 1, (index) {
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

class EnterEditScoreDialogTeamText extends StatelessWidget {
  const EnterEditScoreDialogTeamText({
    required this.team,
    super.key,
  });

  final String team;

  @override
  Widget build(BuildContext context) {
    return Text(
      team,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}

class EnterEditScoreDialogScoreText extends StatelessWidget {
  const EnterEditScoreDialogScoreText({
    required this.score,
    super.key,
  });

  final String score;

  @override
  Widget build(BuildContext context) {
    return Text(
      score,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
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
