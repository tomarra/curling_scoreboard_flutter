import 'package:flutter/material.dart';

class ScoreboardTeamScoreRow extends StatelessWidget {
  const ScoreboardTeamScoreRow({
    required this.upperLimit,
    required this.needExtra,
    required this.scores,
    required this.emptyColor,
    required this.filledColor,
    //required this.onPressed,
    super.key,
  });

  final int upperLimit;
  final bool needExtra;
  final List<int> scores;
  final Color emptyColor;
  final Color filledColor;
  //final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfEntries = upperLimit + (needExtra ? 1 : 0);
    final endContainerWidth = screenWidth / numberOfEntries;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(numberOfEntries, (index) {
          if (index < scores.length) {
            return ScoreContainer(
              score: scores[index],
              color: filledColor,
              width: endContainerWidth,
            );
          } else {
            return ScoreContainer(
              score: -1,
              color: emptyColor,
              width: endContainerWidth,
            );
          }
        }),
      ],
    );
  }
}

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    required this.score,
    required this.color,
    required this.width,
    super.key,
  });

  final int score;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text(
        (score == -1) ? '' : score.toString(),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
