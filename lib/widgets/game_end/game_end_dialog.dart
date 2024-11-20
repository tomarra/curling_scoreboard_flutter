import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';

class GameEndDialog extends StatelessWidget {
  const GameEndDialog({
    required this.ends,
    super.key,
  });

  final List<CurlingEnd> ends;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Game Complete'),
          content: GameSummaryWidget(ends: ends),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Dismiss',
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

class GameSummaryWidget extends StatelessWidget {
  const GameSummaryWidget({
    required this.ends,
    super.key,
  });

  final List<CurlingEnd> ends;

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
        const TableRow(
          children: <Widget>[
            Text('end'),
            Text('scoring team'),
            Text('score'),
            Text('End Time'),
          ],
        ),
        for (final end in ends)
          TableRow(
            children: <Widget>[
              Text(end.endNumber.toString()),
              Text(end.scoringTeamName),
              Text(end.score.toString()),
              Text(end.gameTimeInSeconds.toString()),
            ],
          ),
      ],
    );
  }
}
