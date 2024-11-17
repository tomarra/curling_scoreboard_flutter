import 'package:curling_scoreboard_flutter/widgets/total_score/total_score.dart';
import 'package:flutter/material.dart';

class TotalScoreRow extends StatelessWidget {
  const TotalScoreRow({
    required this.team1Score,
    required this.team1Color,
    required this.team2Score,
    required this.team2Color,
    super.key,
  });

  final int team1Score;
  final Color team1Color;
  final int team2Score;
  final Color team2Color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TeamTotalScoreWidget(
          score: team1Score.toString(),
          backgroundColor: team1Color,
        ),
        TeamTotalScoreWidget(
          score: team2Score.toString(),
          backgroundColor: team2Color,
        ),
      ],
    );
  }
}
