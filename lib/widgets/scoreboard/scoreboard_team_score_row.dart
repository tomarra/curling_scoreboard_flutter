import 'package:flutter/material.dart';

class ScoreboardTeamScoreRow extends StatelessWidget {
  const ScoreboardTeamScoreRow({
    required this.upperLimit,
    required this.needExtra,
    required this.scores,
    required this.emptyColor,
    required this.filledColor,
    required this.onPressed,
    super.key,
  });

  final int upperLimit;
  final bool needExtra;
  final List<int> scores;
  final Color emptyColor;
  final Color filledColor;
  final void Function(int) onPressed;

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
              endNumber: index + 1,
              score: scores[index],
              color: (scores[index] == 0) ? emptyColor : filledColor,
              width: endContainerWidth,
              onPressed: onPressed,
            );
          } else {
            return ScoreContainer(
              endNumber: -1,
              score: -1,
              color: emptyColor,
              width: endContainerWidth,
              onPressed: onPressed,
            );
          }
        }),
      ],
    );
  }
}

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    required this.endNumber,
    required this.score,
    required this.color,
    required this.width,
    required this.onPressed,
    super.key,
  });

  final int endNumber;
  final int score;
  final Color color;
  final double width;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Text(
          (score == -1) ? '' : score.toString(),
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: (color == Colors.red) ? Colors.white : Colors.black,
          ),
        ),
      ),
      onTap: () {
        onPressed(endNumber);
      },
    );
  }
}
