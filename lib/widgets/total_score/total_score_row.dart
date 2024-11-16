import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/widgets/total_score/total_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TotalScoreRow extends StatelessWidget {
  const TotalScoreRow({
    required this.redScore,
    required this.yellowScore,
    super.key,
  });

  final int redScore;
  final int yellowScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TeamTotalScoreWidget(
          score: redScore.toString(),
          backgroundColor: Constants.redTeamColor,
          teamName: AppLocalizations.of(context)!.teamNameRed,
        ),
        TeamTotalScoreWidget(
          score: yellowScore.toString(),
          backgroundColor: Constants.yellowTeamColor,
          teamName: AppLocalizations.of(context)!.teamNameYellow,
        ),
      ],
    );
  }
}
