import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CurlingScoreboardApp());
}

class CurlingScoreboardApp extends StatelessWidget {
  const CurlingScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curling Scoreboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurlingScoreboardScreen(),
    );
  }
}

class EndScore {
  String team;
  List<int> scores;
  String gameTime;

  EndScore({required this.team, required this.scores, required this.gameTime});
}

class CurlingScoreboardScreen extends StatefulWidget {
  const CurlingScoreboardScreen({super.key});

  @override
  _CurlingScoreboardScreenState createState() =>
      _CurlingScoreboardScreenState();
}

class _CurlingScoreboardScreenState extends State<CurlingScoreboardScreen> {
  List<int> redScores = [];
  List<int> yellowScores = [];
  int currentEnd = 1;
  int totalEnds = 8;
  String gameTime = '00:00:00';
  List<EndScore> scores = [];

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
      setState(() {
        updateGameTimeString();
      });
    });
  }

  void updateGameTimeString() {
    Duration duration = Duration(seconds: totalTimerSeconds);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    gameTime =
        "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void updateTotalEnds(int newTotalEnds) {
    setState(() {
      totalEnds = newTotalEnds;
    });
  }

  void enterScore(int score, String team) {
    final endScore = EndScore(team: team, scores: [], gameTime: gameTime);

    setState(() {
      if (team == 'Red') {
        redScores.add(score);
        yellowScores.add(0);
      } else {
        yellowScores.add(score);
        redScores.add(0);
      }
      currentEnd++;

      for (int i = 0; i < redScores.length; i++) {
        endScore.scores.add(redScores[i] + yellowScores[i]);
      }

      scores.add(endScore);
    });
  }

  void resetGame() {
    setState(() {
      redScores.clear();
      yellowScores.clear();
      currentEnd = 1;
      gameTime = '00:00';
      totalTimerSeconds = 0;
      scores.clear();
    });
  }

  void showResetConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reset'),
            content:
                const Text('Are you sure you want to reset the scoreboard?'),
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
        });
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int settingsTotalEnds = totalEnds;

          return AlertDialog(
            title: const Text('Settings'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
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
              )
            ]),
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
        });
  }

  void showScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedTeam = 'Red';
        int selectedScore = 0;

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
                items: <String>['Red', 'Yellow']
                    .map<DropdownMenuItem<String>>((String value) {
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
        toolbarHeight: 30,
        title: const Text('Curling Scoreboard'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showResetConfirmationDialog(context);
                },
                child: const Icon(Icons.replay_outlined),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showScoreDialog(context);
                },
                child: const Icon(Icons.add),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showSettingsDialog(context);
                },
                child: const Icon(Icons.settings),
              )),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                'Red',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
              Text(
                'Yellow',
                style: TextStyle(
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
          LandscapeScoreboard(
              totalEnds: totalEnds,
              redScores: redScores,
              yellowScores: yellowScores),
        ],
      ),
    );
  }
}

class LandscapeScoreboard extends StatelessWidget {
  const LandscapeScoreboard({
    Key? key,
    required this.totalEnds,
    required this.redScores,
    required this.yellowScores,
  }) : super(key: key);

  final int totalEnds;
  final List<int> redScores;
  final List<int> yellowScores;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(width: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...List.generate(totalEnds + 1, (index) => index + 1)
                  .map((end) => Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.blue,
                        ),
                        child: Text(
                          (end > totalEnds) ? "E" : end.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ))
                  .toList(),
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
                      shape: BoxShape.rectangle,
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
                      shape: BoxShape.rectangle,
                      color: Colors.red[200],
                    ),
                  );
                }
              }).toList(),
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
                      shape: BoxShape.rectangle,
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
                      shape: BoxShape.rectangle,
                      color: Colors.yellow[200],
                    ),
                  );
                }
              }).toList(),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class LandscapeScoreboard2 extends StatelessWidget {
  const LandscapeScoreboard2({
    Key? key,
    required this.totalEnds,
    required this.redScores,
    required this.yellowScores,
  }) : super(key: key);

  final int totalEnds;
  final List<int> redScores;
  final List<int> yellowScores;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(totalEnds + 1, (index) => index + 1)
                      .map((end) => Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.blue,
                            ),
                            child: Text(
                              (end > totalEnds) ? "E" : end.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(totalEnds + 1, (index) {
                    if (index < redScores.length) {
                      return Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
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
                          shape: BoxShape.rectangle,
                          color: Colors.red[200],
                        ),
                      );
                    }
                  }).toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(totalEnds + 1, (index) {
                    if (index < yellowScores.length) {
                      return Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
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
                          shape: BoxShape.rectangle,
                          color: Colors.yellow[200],
                        ),
                      );
                    }
                  }).toList(),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
