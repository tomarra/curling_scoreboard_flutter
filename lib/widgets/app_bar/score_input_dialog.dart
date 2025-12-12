import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/l10n/app_localizations.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class ScoreInputDialog extends StatelessWidget {
  const ScoreInputDialog({
    required this.game,
    required this.defaultScore,
    required this.end,
    this.defaultTeam,
    this.initialIsPowerPlay = false,
    this.hammerTeamName,
    super.key,
  });

  final CurlingGame game;
  final int end;
  final String? defaultTeam;
  final int defaultScore;
  final bool initialIsPowerPlay;
  final String? hammerTeamName;

  @override
  Widget build(BuildContext context) {
    var selectedTeam = defaultTeam;
    int? currentTeamSelectedIndex;

    if (defaultTeam != null) {
      currentTeamSelectedIndex =
          defaultTeam == AppLocalizations.of(context)!.teamNameRed ? 0 : 1;
    }

    var selectedScore = defaultScore;
    var currentScoreSelectedIndex = defaultScore;
    var isPowerPlay = initialIsPowerPlay;

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

    final scoreItems = game.numberOfPlayersPerTeam == 2
        ? {
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
          }
        : {
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
        final canUsePowerPlay =
            game.numberOfPlayersPerTeam == 2 && hammerTeamName != null;
        var disablePowerPlay = false;

        if (canUsePowerPlay) {
          debugPrint(
            'DEBUG: Checking Power Play for hammerTeamName: $hammerTeamName',
          );
          debugPrint(
            'DEBUG: hasTeamUsedPowerPlay: ${game.hasTeamUsedPowerPlay(hammerTeamName!)}',
          );

          if (game.hasTeamUsedPowerPlay(hammerTeamName!) &&
              !initialIsPowerPlay) {
            disablePowerPlay = true;
          }
        }

        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.scoreInputDialogTitle(end.toString()),
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

                    if (selectedScore == 0) {
                      selectedTeam = null;
                      currentTeamSelectedIndex = null;
                    }
                  });
                },
              ),
              Opacity(
                opacity: selectedScore > 0 ? 1.0 : 0.3,
                child: AbsorbPointer(
                  absorbing: selectedScore == 0,
                  child: MaterialSegmentedControl(
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
                            ? selectedTeam = AppLocalizations.of(
                                context,
                              )!.teamNameRed
                            : selectedTeam = AppLocalizations.of(
                                context,
                              )!.teamNameYellow;
                      });
                    },
                  ),
                ),
              ),
              if (canUsePowerPlay)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: InkWell(
                    onTap: disablePowerPlay
                        ? null
                        : () {
                            setState(() {
                              isPowerPlay = !isPowerPlay;
                            });
                          },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 2.0,
                            child: Checkbox(
                              value: isPowerPlay,
                              onChanged: disablePowerPlay
                                  ? null
                                  : (value) {
                                      setState(() {
                                        isPowerPlay = value!;
                                      });
                                    },
                              activeColor: Theme.of(context).primaryColor,
                              checkColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Power Play',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: disablePowerPlay
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: (selectedScore > 0 && selectedTeam == null)
                  ? null
                  : () {
                      final newEnd = CurlingEnd(
                        endNumber: end,
                        scoringTeamName: selectedTeam,
                        score: selectedScore,
                        isPowerPlay: isPowerPlay,
                        hammerTeamName: hammerTeamName,
                      );

                      Navigator.pop(context, newEnd);
                    },
              child: Text(
                AppLocalizations.of(context)!.scoreInputEnterButtonLabel,
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

class EnterEditScoreDialogScoreText extends StatelessWidget {
  const EnterEditScoreDialogScoreText({required this.score, super.key});

  final String score;

  @override
  Widget build(BuildContext context) {
    return Text(
      score,
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}

class EnterEditScoreDialogTeamText extends StatelessWidget {
  const EnterEditScoreDialogTeamText({required this.team, super.key});

  final String team;

  @override
  Widget build(BuildContext context) {
    return Text(
      team,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
