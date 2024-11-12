import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameInfoRowWidget extends StatelessWidget {
  const GameInfoRowWidget({
    required this.end,
    required this.gameTime,
    super.key,
  });

  final String end;
  final String gameTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FittedBox(
            child: Text(
              AppLocalizations.of(context)!.gameInfoEndLabel(end),
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            child: Text(
              AppLocalizations.of(context)!.gameInfoGameTimeLabel(gameTime),
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
      ],
    );
  }
}
