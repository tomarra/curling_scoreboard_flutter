import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';

class ScoreboardSettings {
  ScoreboardSettings({
    required this.team1,
    required this.team2,
    required this.numberOfEnds,
    required this.numberOfPlayersPerTeam,
  });

  int numberOfEnds;
  int numberOfPlayersPerTeam;
  CurlingTeam team1;
  CurlingTeam team2;

  int get minutesPerEnd {
    if (numberOfPlayersPerTeam == 4) {
      return Constants.minutesPerEndFourPlayers;
    } else {
      return Constants.minutesPerEndTwoPlayers;
    }
  }
}
