class CurlingEnd {
  CurlingEnd({
    required this.endNumber,
    required this.team,
    required this.score,
    this.gameTimeInSeconds = 0,
  });
  int endNumber;
  String team;
  int score;
  int gameTimeInSeconds;
}
