import 'package:flutter/material.dart';

class ScoreboardTeamScoreRow extends StatelessWidget {
  const ScoreboardTeamScoreRow({
    required this.upperLimit,
    required this.needExtra,
    required this.scores,
    required this.emptyScoreBackgroundColor,
    required this.filledScoreBackgroundColor,
    required this.scoreTextColor,
    required this.scoreTextHighContrastColor,
    required this.onPressed,
    super.key,
  });

  final int upperLimit;
  final bool needExtra;
  final List<String> scores;
  final Color emptyScoreBackgroundColor;
  final Color filledScoreBackgroundColor;
  final Color scoreTextColor;
  final Color scoreTextHighContrastColor;
  final void Function(int) onPressed;

  int _getScoreValue(String score) {
    return int.tryParse(score.replaceAll('*', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfEntries = upperLimit + (needExtra ? 1 : 0);
    // If we have more scores than entries (e.g. extra ends), we need to scroll or adjust.
    // But assuming strict layout for now as per original code which generated fixed columns.
    final endContainerWidth = screenWidth / numberOfEntries;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(numberOfEntries, (index) {
          var textColor = scoreTextColor;
          var scoreValue = 0;

          if (scores.isNotEmpty && index < scores.length) {
            scoreValue = _getScoreValue(scores[index]);
            textColor = findSafeTextColor(
              (scoreValue == 0)
                  ? emptyScoreBackgroundColor
                  : filledScoreBackgroundColor,
            );
          }

          if (index < scores.length) {
            return ScoreContainer(
              endNumber: index + 1,
              score: scores[index],
              backgroundColor: (scoreValue == 0)
                  ? emptyScoreBackgroundColor
                  : filledScoreBackgroundColor,
              textColor: textColor,
              width: endContainerWidth,
              onPressed: onPressed,
            );
          } else {
            return ScoreContainer(
              endNumber: -1,
              score: '',
              backgroundColor: emptyScoreBackgroundColor,
              textColor: textColor,
              width: endContainerWidth,
              onPressed: onPressed,
            );
          }
        }),
      ],
    );
  }

  Color findSafeTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return (luminance > 0.5) ? scoreTextColor : scoreTextHighContrastColor;
  }
}

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({
    required this.endNumber,
    required this.score,
    required this.backgroundColor,
    required this.textColor,
    required this.width,
    required this.onPressed,
    super.key,
  });

  final int endNumber;
  final String score;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(color: backgroundColor),
        child: Text(
          score,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      onTap: () {
        onPressed(endNumber);
      },
    );
  }
}
