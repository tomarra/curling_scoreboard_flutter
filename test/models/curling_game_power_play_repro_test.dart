import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Power Play mechanics - Independent per team', () {
    final game = CurlingGame(
      team1: CurlingTeam(
        name: 'Red',
        color: Colors.red,
        textColor: Colors.white,
        hasHammer: false,
      ),
      team2: CurlingTeam(
        name: 'Yellow',
        color: Colors.yellow,
        textColor: Colors.black,
        hasHammer: true, // Yellow starts with hammer
      ),
      numberOfEnds: 8,
      numberOfPlayersPerTeam: 2,
      ends: [],
    );

    // End 1: Yellow has hammer. Yellow scores 1. Uses Power Play.
    game.ends.add(
      CurlingEnd(
        endNumber: 1,
        scoringTeamName: 'Yellow',
        score: 1,
        hammerTeamName: 'Yellow',
        isPowerPlay: true, // Yellow uses PP
      ),
    );
    game.evaluateHammer(); // Yellow scored, so Red gets hammer?
    // Normal logic: Scoring team loses hammer. So Red gets hammer.

    expect(game.hasTeamUsedPowerPlay('Yellow'), isTrue);
    expect(game.hasTeamUsedPowerPlay('Red'), isFalse);
    expect(game.whichTeamHasHammer().name, 'Red');

    // End 2: Red has hammer.
    // Check if Red can use Power Play.
    // Logic in UI: hasTeamUsedPowerPlay(hammerTeamName) -> hasTeamUsedPowerPlay('Red')
    expect(game.hasTeamUsedPowerPlay('Red'), isFalse);

    // End 2: Red scores 2. Uses Power Play.
    game.ends.add(
      CurlingEnd(
        endNumber: 2,
        scoringTeamName: 'Red',
        score: 2,
        hammerTeamName: 'Red',
        isPowerPlay: true,
      ),
    );
    game.evaluateHammer();

    expect(game.hasTeamUsedPowerPlay('Red'), isTrue);
    expect(game.team1DisplayScores, ['0', '2*']);
    expect(game.team2DisplayScores, ['1*', '0']);
  });
}
