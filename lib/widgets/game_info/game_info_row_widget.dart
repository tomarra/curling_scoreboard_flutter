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
        Text(
          AppLocalizations.of(context)!.gameInfoEndLabel(end),
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 16),
        Text(
          AppLocalizations.of(context)!.gameInfoGameTimeLabel(gameTime),
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
