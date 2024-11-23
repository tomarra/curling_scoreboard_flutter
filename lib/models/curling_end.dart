class CurlingEnd {
  CurlingEnd({
    required this.endNumber,
    required this.scoringTeamName,
    required this.score,
    this.gameTimeInSeconds = -1,
  });
  int endNumber;
  String scoringTeamName;
  int score;
  int gameTimeInSeconds;
}
