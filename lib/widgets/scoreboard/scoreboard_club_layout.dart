import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:flutter/material.dart';

class ScoreboardClubLayout extends StatelessWidget {
  const ScoreboardClubLayout({
    required this.team1Scores,
    required this.team2Scores,
    required this.team1Color,
    required this.team2Color,
    required this.team1TextColor,
    required this.team2TextColor,
    required this.onPressed,
    super.key,
  });

  final List<int> team1Scores;
  final List<int> team2Scores;
  final Color team1Color;
  final Color team2Color;
  final Color team1TextColor;
  final Color team2TextColor;
  final void Function(int) onPressed;

  static const int maxScore = 12;

  @override
  Widget build(BuildContext context) {
    final team1Cumulative = _calculateCumulativeMap(team1Scores);
    final team2Cumulative = _calculateCumulativeMap(team2Scores);

    return LayoutBuilder(
      builder: (context, constraints) {
        final widthPerItem = constraints.maxWidth / maxScore;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(maxScore, (index) {
            final scoreValue = index + 1;
            final team1End = team1Cumulative[scoreValue];
            final team2End = team2Cumulative[scoreValue];

            return SizedBox(
              width: widthPerItem,
              child: Column(
                children: [
                  // Team 1 Row (Top)
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: team1End != null
                          ? InkWell(
                              onTap: () => onPressed(team1End),
                              child: _EndMarker(
                                endNumber: team1End,
                                color: team1Color,
                                textColor: team1TextColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                  // Middle Row (The Number)
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constants.primaryThemeColor,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      scoreValue.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Team 2 Row (Bottom)
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 4),
                      child: team2End != null
                          ? InkWell(
                              onTap: () => onPressed(team2End),
                              child: _EndMarker(
                                endNumber: team2End,
                                color: team2Color,
                                textColor: team2TextColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Map<int, int> _calculateCumulativeMap(List<int> scores) {
    final map = <int, int>{};
    int currentTotal = 0;
    for (int i = 0; i < scores.length; i++) {
      final score = scores[i];
      if (score > 0) {
        currentTotal += score;
        if (currentTotal <= maxScore) {
          map[currentTotal] = i + 1; // End number is index + 1
        }
      }
    }
    return map;
  }
}

class _EndMarker extends StatelessWidget {
  const _EndMarker({
    required this.endNumber,
    required this.color,
    required this.textColor,
  });

  final int endNumber;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Text(
              endNumber.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: constraints.maxWidth * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}
