import 'package:curling_scoreboard_flutter/constants.dart';

class ScoreboardSettings {
  ScoreboardSettings({this.numberOfEnds = 8, this.numberOfPlayersPerTeam = 4});

  int numberOfEnds;
  int numberOfPlayersPerTeam;

  int get minutesPerEnd {
    if (numberOfPlayersPerTeam == 4) {
      return Constants.minutesPerEndFourPlayers;
    } else {
      return Constants.minutesPerEndTwoPlayers;
    }
  }
}
