import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class GameEndDialog extends StatelessWidget {
  const GameEndDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Game Complete'),
          content: Text('data goes here'),
          actions: [
            ElevatedButton(
              onPressed: () {
                /*final newSettings = ScoreboardSettings(
                  numberOfEnds: settingsTotalEnds,
                  numberOfPlayersPerTeam: settingsNumberOfPlayersPerTeam,
                );*/

                Navigator.pop(context);
              },
              child: Text(
                'Dismiss',
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
