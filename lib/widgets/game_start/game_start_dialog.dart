import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class GameStartDialog extends StatelessWidget {
  const GameStartDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final numberOfEnds = {
      2: const Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: GameStartSegmentControlText(text: '2'),
      ),
      4: const GameStartSegmentControlText(text: '4'),
      6: const GameStartSegmentControlText(text: '6'),
      8: const GameStartSegmentControlText(text: '8'),
      10: const GameStartSegmentControlText(text: '10'),
    };

    var settingsTotalEnds = 8;
    var currentNumberOfEndsSelectedIndex = 8;

    final numberOfPlayersPerTeam = {
      2: const Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: GameStartSegmentControlText(text: '2'),
      ),
      4: const GameStartSegmentControlText(text: '4'),
    };

    var settingsNumberOfPlayersPerTeam = 4;
    var currentNumberOfPlayersPerTeamSelectedIndex = 4;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Game Start'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Number of Ends',
                      style: const TextStyle(fontSize: 40),
                    ),
                    MaterialSegmentedControl(
                      children: numberOfEnds,
                      selectionIndex: currentNumberOfEndsSelectedIndex,
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
                          currentNumberOfEndsSelectedIndex = index;
                          settingsTotalEnds = index;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Players per Team',
                      style: const TextStyle(fontSize: 40),
                    ),
                    MaterialSegmentedControl(
                      children: numberOfPlayersPerTeam,
                      selectionIndex:
                          currentNumberOfPlayersPerTeamSelectedIndex,
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
                          currentNumberOfPlayersPerTeamSelectedIndex = index;
                          settingsNumberOfPlayersPerTeam = index;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newSettings = ScoreboardSettings(
                  numberOfEnds: settingsTotalEnds,
                  numberOfPlayersPerTeam: settingsNumberOfPlayersPerTeam,
                );

                Navigator.pop(context, newSettings);
              },
              child: Text(
                'Start Game',
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
}

class GameStartSegmentControlText extends StatelessWidget {
  const GameStartSegmentControlText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
