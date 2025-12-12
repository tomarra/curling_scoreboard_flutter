import 'package:flutter/material.dart';

class ScoreboardTeamScoreRow extends StatelessWidget {
  const ScoreboardTeamScoreRow({
    required this.upperLimit,
    required this.needExtra,
    required this.scores,
    required this.powerPlays,
    required this.emptyScoreBackgroundColor,
    required this.filledScoreBackgroundColor,
    required this.scoreTextColor,
    required this.scoreTextHighContrastColor,
    required this.onPressed,
    super.key,
  });

  final int upperLimit;
  final bool needExtra;
  final List<int> scores;
  final List<bool> powerPlays;
  final Color emptyScoreBackgroundColor;
  final Color filledScoreBackgroundColor;
  final Color scoreTextColor;
  final Color scoreTextHighContrastColor;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfEntries = upperLimit + (needExtra ? 1 : 0);
    // If we have more scores than entries (e.g. extra ends), we need to scroll
    // or adjust. But assuming strict layout for now as per original code which
    // generated fixed columns.
    final endContainerWidth = screenWidth / numberOfEntries;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(numberOfEntries, (index) {
          var textColor = scoreTextColor;
          var scoreValue = 0;

          if (scores.isNotEmpty && index < scores.length) {
            scoreValue = scores[index];
            textColor = findSafeTextColor(
              (scoreValue == 0)
                  ? emptyScoreBackgroundColor
                  : filledScoreBackgroundColor,
            );
          }

          if (index < scores.length) {
            return ScoreContainer(
              endNumber: index + 1,
              score: scores[index].toString(),
              isPowerPlay: powerPlays[index],
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
              isPowerPlay: false,
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
    required this.isPowerPlay,
    required this.backgroundColor,
    required this.textColor,
    required this.width,
    required this.onPressed,
    super.key,
  });

  final int endNumber;
  final String score;
  final bool isPowerPlay;
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isPowerPlay)
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '*',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            Text(
              score,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        onPressed(endNumber);
      },
    );
  }
}
