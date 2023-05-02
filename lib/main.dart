import 'dart:async';

import 'package:curling_scoreboard_flutter/models/models.dart';
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
        primarySwatch: Colors.blue,
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
  int currentEnd = 1;
  int totalEnds = 8;
  String gameTime = '00:00:00';
  List<CurlingEnd> ends = [];

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
          title: const Text('Reset'),
          content: const Text('Are you sure you want to reset the scoreboard?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
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
              title: const Text('Settings'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text('Number of Ends: '),
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
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    updateTotalEnds(settingsTotalEnds);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirm'),
                )
              ],
            );
          },
        );
      },
    );
  }

  void showAddScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var selectedTeam = AppLocalizations.of(context)!.teamNameRed;
        var selectedScore = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Score'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedTeam,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTeam = newValue!;
                      });
                    },
                    items: <String>[
                      AppLocalizations.of(context)!.teamNameRed,
                      AppLocalizations.of(context)!.teamNameYellow
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
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
              actions: [
                ElevatedButton(
                  onPressed: () {
                    enterScore(selectedScore, selectedTeam);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Enter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditScoreDialog(
    BuildContext context,
    String end,
    String team,
    int score,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var selectedTeam = team;
        var selectedScore = score;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Score - End $end'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedTeam,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTeam = newValue!;
                      });
                    },
                    items: <String>[
                      AppLocalizations.of(context)!.teamNameRed,
                      AppLocalizations.of(context)!.teamNameYellow
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
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
              actions: [
                ElevatedButton(
                  onPressed: () {
                    editScore(int.parse(end), selectedScore, selectedTeam);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Enter'),
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

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        title: Text(AppLocalizations.of(context)!.appBarTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showResetConfirmationDialog(context);
              },
              child: const Icon(Icons.replay_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showAddScoreDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showSettingsDialog(context);
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                AppLocalizations.of(context)!.teamNameRed,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.teamNameYellow,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                redScores.fold(0, (a, b) => a + b).toString(),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                yellowScores.fold(0, (a, b) => a + b).toString(),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'End $currentEnd',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Text(
                'Game Time: $gameTime',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ...List.generate(totalEnds + 1, (index) => index + 1).map(
                      (end) => InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            (end > totalEnds) ? 'E' : end.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (ends.length >= end) {
                            showEditScoreDialog(
                              context,
                              (end).toString(),
                              AppLocalizations.of(context)!.teamNameRed,
                              0,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ...List.generate(totalEnds + 1, (index) {
                      if (index < redScores.length) {
                        return Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Text(
                            redScores[index].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                          ),
                        );
                      }
                    })
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ...List.generate(totalEnds + 1, (index) {
                      if (index < yellowScores.length) {
                        return Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                          ),
                          child: Text(
                            yellowScores[index].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.yellow[200],
                          ),
                        );
                      }
                    })
                  ],
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 30,
      title: Text(AppLocalizations.of(context)!.appBarTitle),
      actions: <Widget>[
        buildResetButton(context),
        buildAddScoreButton(context),
        buildSettingsButton(context),
      ],
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
          showAddScoreDialog(context);
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
        const SizedBox(height: 16),
        buildTeamNamesRow(),
        const SizedBox(height: 16),
        buildScoresRow(),
        const SizedBox(height: 32),
        buildGameInfoRow(),
        const SizedBox(height: 16),
        Expanded(
          child: buildEndsContainer(),
        ),
      ],
    );
  }

  Widget buildTeamNamesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          AppLocalizations.of(context)!.teamNameRed,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.red,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.teamNameYellow,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }

  Widget buildScoresRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRedScoreText(),
        buildYellowScoreText(),
      ],
    );
  }

  Widget buildRedScoreText() {
    return Text(
      redScores.fold(0, (a, b) => a + b).toString(),
      style: const TextStyle(
        fontSize: 48,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildYellowScoreText() {
    return Text(
      yellowScores.fold(0, (a, b) => a + b).toString(),
      style: const TextStyle(
        fontSize: 48,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildGameInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'End $currentEnd',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 16),
        Text(
          'Game Time: $gameTime',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget buildEndsContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final endContainerWidth = screenWidth / (totalEnds + 1);

    return Column(
      children: [
        const SizedBox(width: 16),
        buildEndsRow(endContainerWidth),
        const SizedBox(width: 16),
        buildRedScoresRow(endContainerWidth),
        const SizedBox(width: 16),
        buildYellowScoresRow(endContainerWidth),
      ],
    );
  }

  Widget buildEndsRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...List.generate(totalEnds + 1, (index) => index + 1).map(
          (end) => InkWell(
            child: buildEndContainer(end, endContainerWidth),
            onTap: () {
              if (ends.length >= end) {
                showEditScoreDialog(
                  context,
                  (end).toString(),
                  AppLocalizations.of(context)!.teamNameRed,
                  0,
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
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        (end > totalEnds) ? 'E' : end.toString(),
        style: const TextStyle(
          fontSize: 18,
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
        const SizedBox(height: 8),
        ...List.generate(totalEnds + 1, (index) {
          if (index < redScores.length) {
            return buildScoreContainer(
              redScores[index],
              Colors.red,
              endContainerWidth,
            );
          } else {
            return buildScoreContainer(-1, Colors.red[200]!, endContainerWidth);
          }
        }),
      ],
    );
  }

  Widget buildYellowScoresRow(double endContainerWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...List.generate(totalEnds + 1, (index) {
          if (index < yellowScores.length) {
            return buildScoreContainer(
              yellowScores[index],
              Colors.yellow,
              endContainerWidth,
            );
          } else {
            return buildScoreContainer(
              -1,
              Colors.yellow[200]!,
              endContainerWidth,
            );
          }
        }),
      ],
    );
  }

  Widget buildScoreContainer(int score, Color color, double width) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text(
        (score == -1) ? '' : score.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
