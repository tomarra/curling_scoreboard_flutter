import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Power Play mechanics (2 players)', () {
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
        hasHammer: true,
      ),
      numberOfEnds: 8,
      numberOfPlayersPerTeam: 2,
      ends: [],
    );

    // End 1: Team 1 scores, Team 2 uses hammer (no power play)
    game.ends.add(
      CurlingEnd(
        endNumber: 1,
        scoringTeamName: 'Red',
        score: 1,
        hammerTeamName: 'Yellow',
      ),
    );
    game.evaluateHammer();

    expect(game.hasTeamUsedPowerPlay('Yellow'), isFalse);
    expect(game.team1DisplayScores, ['1']);
    expect(game.team2DisplayScores, ['0']);

    // End 2: Team 2 scores, Team 2 has hammer (calls power play)
    // Wait, who has hammer in end 2?
    // In End 1, Red scored. So Red lost hammer?
    // Standard curling: Scoring team gives up hammer.
    // Red scored, so Red gives hammer to Yellow? No.
    // Starting hammer: Yellow.
    // End 1: Red scores.
    // Hammer logic:
    // If scoring team == team1 (Red), team1.hasHammer = false,
    // team2.hasHammer = true.
    // So Yellow keeps hammer? No.
    // If Red scored, Red didn't have hammer (stole?).
    // Or Red had hammer and scored?
    // If Red had hammer and scored, Red loses hammer. Yellow gets hammer.
    // If Red stole (Yellow had hammer), Yellow keeps hammer?
    // Standard rules: If you score, the OTHER team gets hammer.
    // If you blank, you keep hammer.
    // Here: Red scores 1.
    // If Yellow had hammer: Yellow failed to score.
    //Yellow might keep hammer only if blank?
    // No, usually if you give up a steal, you lose hammer?
    // Actually, in standard curling:
    // Team A has hammer. Team A scores -> Team B gets hammer.
    // Team A has hammer. Team B scores (steal) -> Team A gets hammer.
    // Team A has hammer. Blank end -> Team A keeps hammer.

    // Let's check `evaluateHammer` logic in `curling_game.dart`.
    /*
    if (lastEnd.scoringTeamName == team1.name) {
      team1.hasHammer = false;
      team2.hasHammer = true;
    } else {
      team1.hasHammer = true;
      team2.hasHammer = false;
    }
    */
    // This logic says: If Team 1 scores, Team 2 gets hammer.
    // Regardless of who had it before.
    // So if Red (Team 1) scores, Yellow (Team 2) gets hammer.

    // So End 2: Yellow has hammer.
    // Yellow calls Power Play.
    game.ends.add(
      CurlingEnd(
        endNumber: 2,
        scoringTeamName: 'Yellow',
        score: 2,
        hammerTeamName: 'Yellow',
        isPowerPlay: true,
      ),
    );
    game.evaluateHammer();

    expect(game.hasTeamUsedPowerPlay('Yellow'), isTrue);
    expect(game.team1DisplayScores, [
      '1',
      '0',
    ]); // Team 1 gets 0, no star (Yellow used PP)
    expect(game.team2DisplayScores, ['0', '2*']);
  });
}
