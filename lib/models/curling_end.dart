class CurlingEnd {
  CurlingEnd({
    required this.endNumber,
    required this.score,
    this.scoringTeamName,
    this.gameTimeInSeconds = -1,
    this.isPowerPlay = false,
    this.hammerTeamName,
  });
  int endNumber;
  String? scoringTeamName;
  int score;
  int gameTimeInSeconds;
  bool isPowerPlay;
  String? hammerTeamName;
}
