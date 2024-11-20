import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameEndDialog extends StatelessWidget {
  const GameEndDialog({
    required this.gameObject,
    super.key,
  });

  final CurlingGame gameObject;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.gameEndDialogTitle),
          content: GameSummaryWidget(
            team1Name: gameObject.team1.name,
            team2Name: gameObject.team2.name,
            team1Color: gameObject.team1.color,
            team2Color: gameObject.team2.color,
            ends: gameObject.ends,
            team1TotalScore: gameObject.team1TotalScore,
            team2TotalScore: gameObject.team2TotalScore,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.gameEndDialogButtonLabelDismiss,
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

class GameSummaryWidget extends StatelessWidget {
  const GameSummaryWidget({
    required this.team1Name,
    required this.team2Name,
    required this.team1Color,
    required this.team2Color,
    required this.ends,
    required this.team1TotalScore,
    required this.team2TotalScore,
    super.key,
  });

  final String team1Name;
  final String team2Name;
  final Color team1Color;
  final Color team2Color;
  final List<CurlingEnd> ends;
  final int team1TotalScore;
  final int team2TotalScore;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            const Text('End'),
            Text(team1Name),
            Text(team2Name),
            const Text('End Time'),
            const Text('Game Time'),
          ],
        ),
        for (final end in ends)
          TableRow(
            children: <Widget>[
              Text(end.endNumber.toString()),
              Text(
                (end.scoringTeamName == team1Name) ? end.score.toString() : '0',
              ),
              Text(
                (end.scoringTeamName == team2Name) ? end.score.toString() : '0',
              ),
              Text(
                (end.endNumber == 1)
                    ? _printDurationInMinutes(
                        Duration(seconds: end.gameTimeInSeconds),
                      )
                    : _printDurationInMinutes(
                        Duration(
                          seconds: end.gameTimeInSeconds -
                              ends[end.endNumber - 2].gameTimeInSeconds,
                        ),
                      ),
              ),
              Text(
                _printDurationInHours(
                  Duration(seconds: end.gameTimeInSeconds),
                ),
              ),
            ],
          ),
        TableRow(
          children: <Widget>[
            const Text('Totals'),
            Text(team1TotalScore.toString()),
            Text(team2TotalScore.toString()),
            const Text(''),
            const Text(''),
          ],
        ),
      ],
    );
  }

  String _printDurationInMinutes(Duration duration) {
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  String _printDurationInHours(Duration duration) {
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}
