import 'package:flutter/material.dart';

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
