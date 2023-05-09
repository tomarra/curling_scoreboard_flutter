import 'package:flutter/material.dart';

class TeamTotalScoreWidget extends StatelessWidget {
  const TeamTotalScoreWidget({
    required this.teamName,
    required this.score,
    required this.backgroundColor,
    super.key,
  });

  final String score;
  final Color backgroundColor;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final teamTotalScoreContainerWidth = screenWidth / 2;

    return Container(
      color: backgroundColor,
      width: teamTotalScoreContainerWidth,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          Expanded(
            child: FittedBox(
              child: Text(
                score,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
