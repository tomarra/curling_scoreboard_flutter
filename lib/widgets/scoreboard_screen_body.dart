import 'package:curling_scoreboard_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ScoreboardScreenBody extends StatelessWidget {
  const ScoreboardScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*Flexible(flex: 9, child: buildScoresRow()),
        Flexible(
          child: GameInfoRowWidget(
            end: (currentEnd > totalEnds)
                ? AppLocalizations.of(context)!.gameInfoExtraEndText
                : currentEnd.toString(),
            gameTime: gameTime,
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: buildEndsContainer(),
        ),*/
      ],
    );
  }
}
