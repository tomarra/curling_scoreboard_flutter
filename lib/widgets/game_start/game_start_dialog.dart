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
    var settingsTotalEnds = Constants.defaultTotalEnds;
    var currentNumberOfEndsSelectedIndex = Constants.defaultTotalEnds;

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

    var settingsNumberOfPlayersPerTeam =
        Constants.defaultNumberOfPlayersPerTeam;
    var currentNumberOfPlayersPerTeamSelectedIndex =
        Constants.defaultNumberOfPlayersPerTeam;

    final numberOfPlayersPerTeam = {
      2: const Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: GameStartSegmentControlText(
          text: '2',
          subtext: '13 minutes per end',
        ),
      ),
      4: const GameStartSegmentControlText(
        text: '4',
        subtext: '15 minutes per end',
      ),
    };

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.gameStartDialogTitle),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .gameStartDialogFormLabelNumberOfEnds,
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
                      AppLocalizations.of(context)!
                          .gameStartDialogFormLabelPlayersPerTeam,
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
                final team1 = CurlingTeam(
                  name: AppLocalizations.of(context)!.teamNameRed,
                  color: Constants.redTeamColor,
                  accentColor: Constants.redTeamAccentColor,
                );
                final team2 = CurlingTeam(
                  name: AppLocalizations.of(context)!.teamNameYellow,
                  color: Constants.yellowTeamColor,
                  accentColor: Constants.yellowTeamAccentColor,
                );

                final newCurlingGame = CurlingGame(
                  team1: team1,
                  team2: team2,
                  numberOfEnds: settingsTotalEnds,
                  numberOfPlayersPerTeam: settingsNumberOfPlayersPerTeam,
                );

                Navigator.pop(context, newCurlingGame);
              },
              child: const Text(
                'Start Game',
                style: TextStyle(
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
    this.subtext = '',
    super.key,
  });

  final String text;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    if (subtext == '') {
      return basicText(text);
    } else {
      return Column(
        children: [
          basicText(text),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }

  Text basicText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
