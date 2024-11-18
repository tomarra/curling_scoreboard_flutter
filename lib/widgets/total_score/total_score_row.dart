import 'package:curling_scoreboard_flutter/widgets/total_score/total_score.dart';
import 'package:flutter/material.dart';

class TotalScoreRow extends StatelessWidget {
  const TotalScoreRow({
    required this.team1Score,
    required this.team1Color,
    required this.team2Score,
    required this.team2Color,
    required this.endNumber,
    super.key,
  });

  final int team1Score;
  final Color team1Color;
  final int team2Score;
  final Color team2Color;
  final int endNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
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
        ),
        Align(
          child: FractionallySizedBox(
            widthFactor: 0.125,
            heightFactor: 1,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: ColoredBox(
                color: Colors.white,
                child: Text(
                  endNumber.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
