import 'package:curling_scoreboard_flutter/constants.dart';
import 'package:curling_scoreboard_flutter/l10n/app_localizations.dart';
import 'package:curling_scoreboard_flutter/models/models.dart';
import 'package:curling_scoreboard_flutter/widgets/app_bar/score_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('Power Play checkbox state respects team usage', (
    WidgetTester tester,
  ) async {
    // Setup game: 2 players, Red starts with hammer.
    final game = CurlingGame(
      team1: CurlingTeam(
        name: 'Red',
        color: Constants.redTeamColor,
        textColor: Constants.textHighContrastColor,
        hasHammer: true,
      ),
      team2: CurlingTeam(
        name: 'Yellow',
        color: Constants.yellowTeamColor,
        textColor: Constants.textDefaultColor,
        hasHammer: false,
      ),
      numberOfEnds: 8,
      numberOfPlayersPerTeam: 2,
      ends: [],
    );

    // End 1: Red has hammer. Uses Power Play.
    // We are simulating the UI state for End 1 entry.
    // Red has hammer. No power plays used yet.
    await tester.pumpWidget(
      wrapWithMaterialApp(
        ScoreInputDialog(
          game: game,
          defaultScore: 0,
          end: 1,
          defaultTeam: 'Red',
          hammerTeamName: 'Red',
        ),
      ),
    );

    expect(find.text('Power Play'), findsOneWidget);
    // Checkbox should be enabled.
    final checkbox1 = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox1.onChanged, isNotNull);

    // Simulate "entering" the score in the game
    // (UI doesn't update game directly, main does).
    // So we update the game model manually to simulate the save.
    game.ends.add(
      CurlingEnd(
        endNumber: 1,
        scoringTeamName: 'Red',
        score: 1,
        hammerTeamName: 'Red',
        isPowerPlay: true,
      ),
    );
    // Red scored, so Red loses hammer. Yellow gets hammer.
    game.evaluateHammer();

    expect(game.whichTeamHasHammer().name, 'Yellow');
    expect(game.hasTeamUsedPowerPlay('Red'), isTrue);
    expect(game.hasTeamUsedPowerPlay('Yellow'), isFalse);

    // End 2: Yellow has hammer.
    // Open dialog for End 2.
    await tester.pumpWidget(
      wrapWithMaterialApp(
        ScoreInputDialog(
          game: game,
          defaultScore: 0,
          end: 2,
          defaultTeam: 'Yellow',
          hammerTeamName: 'Yellow', // Passed from main
        ),
      ),
    );

    // Checkbox should be ENABLED for Yellow because Yellow hasn't used it.
    // If bug exists, it might be disabled.
    final checkbox2 = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(
      checkbox2.onChanged,
      isNotNull,
      reason: 'Power Play should be enabled for Yellow',
    );

    // Logic check:
    // Code says: if (game.hasTeamUsedPowerPlay(hammerTeamName!) ...)
    // hammerTeamName is 'Yellow'. hasTeamUsedPowerPlay('Yellow') is false.
    // So it should be enabled.

    // IF the user says "refreshed based on selected scoring team",
    // maybe they are seeing a case where hammerTeamName passed in is NOT what
    // they expect?
  });
}
