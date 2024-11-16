import 'package:flutter/material.dart';

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
