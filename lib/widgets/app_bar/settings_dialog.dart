import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:curling_scoreboard_flutter/src/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    required this.settings,
    super.key,
  });

  final ScoreboardSettings settings;

  @override
  Widget build(BuildContext context) {
    final numberOfEnds = {
      2: const Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: NumberOfEndsText(score: '2'),
      ),
      4: const NumberOfEndsText(score: '4'),
      6: const NumberOfEndsText(score: '6'),
      8: const NumberOfEndsText(score: '8'),
      10: const NumberOfEndsText(score: '10'),
    };

    var settingsTotalEnds = settings.numberOfEnds;
    var currentNumberOfEndsSelectedIndex = settings.numberOfEnds;

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
                      AppLocalizations.of(context)!.settingsLabelNumberOfEnds,
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
                final newSettings = ScoreboardSettings(
                  numberOfEnds: settingsTotalEnds,
                );

                Navigator.pop(context, newSettings);
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
  }
}

class NumberOfEndsText extends StatelessWidget {
  const NumberOfEndsText({
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
