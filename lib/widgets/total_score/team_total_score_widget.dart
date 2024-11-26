import 'package:flutter/material.dart';

enum HammerIconPosition { left, right }

class TeamTotalScoreWidget extends StatelessWidget {
  const TeamTotalScoreWidget({
    required this.score,
    required this.backgroundColor,
    this.shouldShowHammerIcon = false,
    this.hammerIconPosition = HammerIconPosition.right,
    super.key,
  });

  final String score;
  final Color backgroundColor;
  final bool shouldShowHammerIcon;
  final HammerIconPosition hammerIconPosition;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final teamTotalScoreContainerWidth = screenWidth / 2;

    return Stack(
      children: [
        Container(
          color: backgroundColor,
          width: teamTotalScoreContainerWidth,
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
        if (shouldShowHammerIcon)
          Positioned(
            top: 10,
            left: (hammerIconPosition == HammerIconPosition.left) ? 10 : null,
            right: (hammerIconPosition == HammerIconPosition.right) ? 10 : null,
            child: const Icon(
              Icons.hardware_sharp,
              color: Colors.black,
              size: 150,
            ),
          ),
      ],
    );
  }
}
