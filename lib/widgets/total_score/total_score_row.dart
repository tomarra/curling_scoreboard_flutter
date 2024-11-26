import 'package:curling_scoreboard_flutter/widgets/total_score/total_score.dart';
import 'package:flutter/material.dart';

class TotalScoreRow extends StatelessWidget {
  const TotalScoreRow({
    required this.team1Score,
    required this.team1Color,
    required this.team1HasHammer,
    required this.team2Score,
    required this.team2Color,
    required this.team2HasHammer,
    required this.endNumber,
    super.key,
  });

  final int team1Score;
  final Color team1Color;
  final bool team1HasHammer;
  final int team2Score;
  final Color team2Color;
  final bool team2HasHammer;
  final String endNumber;

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
              shouldShowHammerIcon: team1HasHammer,
              hammerIconPosition: HammerIconPosition.left,
            ),
            TeamTotalScoreWidget(
              score: team2Score.toString(),
              backgroundColor: team2Color,
              shouldShowHammerIcon: team2HasHammer,
            ),
          ],
        ),
        Align(
          child: FractionallySizedBox(
            widthFactor: 0.125,
            heightFactor: 0.7,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: ColoredBox(
                color: Colors.white,
                child: Text(
                  endNumber,
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
