import 'package:flutter/material.dart';

class TeamTotalScoreWidget extends StatelessWidget {
  const TeamTotalScoreWidget({
    required this.score,
    required this.backgroundColor,
    this.shouldShowHammerIcon = false,
    super.key,
  });

  final String score;
  final Color backgroundColor;
  final bool shouldShowHammerIcon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final teamTotalScoreContainerWidth = screenWidth / 2;

    return Container(
      color: backgroundColor,
      width: teamTotalScoreContainerWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (shouldShowHammerIcon)
            const Icon(
              Icons.hardware_sharp,
              color: Colors.black,
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
