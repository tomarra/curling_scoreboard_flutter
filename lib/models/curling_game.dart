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
  int currentPlayingEnd = 1;

  String get currentPlayingEndForDisplay {
    if (currentPlayingEnd <= numberOfEnds) {
      return currentPlayingEnd.toString();
    } else {
      return 'E';
    }
  }

  bool get isGameComplete {
    if ((ends.length >= numberOfEnds) && (team1TotalScore != team2TotalScore)) {
      return true;
    } else {
      return false;
    }
  }

  int get minutesPerEnd {
    if (numberOfPlayersPerTeam == 4) {
      return Constants.minutesPerEndFourPlayers;
    } else {
      return Constants.minutesPerEndTwoPlayers;
    }
  }

  int get team1TotalScore {
    return ends
        .where((end) => end.scoringTeamName == team1.name)
        .map((end) => end.score)
        .fold(0, (a, b) => a + b);
  }

  int get team2TotalScore {
    return ends
        .where((end) => end.scoringTeamName == team2.name)
        .map((end) => end.score)
        .fold(0, (a, b) => a + b);
  }

  List<int> get team1ScoresByEnd {
    final returnValue = <int>[];

    for (final end in ends) {
      if (end.scoringTeamName == team1.name) {
        returnValue.add(end.score);
      } else {
        returnValue.add(0);
      }
    }

    return returnValue;
  }

  List<int> get team2ScoresByEnd {
    final returnValue = <int>[];

    for (final end in ends) {
      if (end.scoringTeamName == team2.name) {
        returnValue.add(end.score);
      } else {
        returnValue.add(0);
      }
    }

    return returnValue;
  }

  void evaluateHammer() {
    final lastEnd = ends.last;

    if (lastEnd.scoringTeamName == team1.name) {
      team1.hasHammer = false;
      team2.hasHammer = true;
    } else {
      team1.hasHammer = true;
      team2.hasHammer = false;
    }
  }
}
