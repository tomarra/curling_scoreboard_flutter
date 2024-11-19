import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';

class CurlingGame {
  CurlingGame({
    required this.team1,
    required this.team2,
    required this.numberOfEnds,
    required this.numberOfPlayersPerTeam,
    this.ends = const [],
  });

  CurlingTeam team1;
  CurlingTeam team2;
  int numberOfEnds;
  int numberOfPlayersPerTeam;
  List<CurlingEnd> ends;

  int get minutesPerEnd {
    if (numberOfPlayersPerTeam == 4) {
      return Constants.minutesPerEndFourPlayers;
    } else {
      return Constants.minutesPerEndTwoPlayers;
    }
  }
}
