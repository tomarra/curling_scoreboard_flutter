import 'package:curling_scoreboard_flutter/l10n/l10n.dart';
import 'package:curling_scoreboard_flutter/scoreboard/scoreboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScoreboardBloc(ticker: const Ticker()),
      child: const ScoreboardView(),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: const ScoreboardAppBar(),
      body: const ScoreboardBody(),
      /*floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<ScoreboardCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<ScoreboardCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),*/
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreboardBloc, ScoreboardState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              ScoreboardInitial() => [
                  FloatingActionButton(
                    child: const Icon(Icons.play_arrow),
                    onPressed: () => context
                        .read<ScoreboardBloc>()
                        .add(ScoreboardStarted(duration: state.duration)),
                  ),
                ],
              ScoreboardInProgress() => [
                  FloatingActionButton(
                    child: const Icon(Icons.replay),
                    onPressed: () {
                      context
                          .read<ScoreboardBloc>()
                          .add(const ScoreboardReset());
                    },
                  ),
                ],
            },
          ],
        );
      },
    );
  }
}

class ScoreboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScoreboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      toolbarHeight: 700,
      title: Text(l10n.appBarTitle),
      actions: <Widget>[
        //AddScoreAppBarButton(),
        //buildResetButton(context),
        //buildAddScoreButton(context),
        //buildSettingsButton(context),
      ],
    );
  }
}

/*class AddScoreAppBarButton extends StatelessWidget {
  const AddScoreAppBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => context.read<ScoreboardCubit>().showScoreEntry(),
    );
  }
}*/

/*class ScoreboardText extends StatelessWidget {
  const ScoreboardText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((ScoreboardCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}*/

class ScoreboardBody extends StatelessWidget {
  const ScoreboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(flex: 7, child: TotalScoreWidget()),
        Flexible(flex: 1, child: GameInfoWidget(end: '1', gameTime: '10:00')),
        Flexible(flex: 2, child: ScoreboardWidget()),
        Actions(),
        //const ScoreboardButtons(),
      ],
    );
  }
}

class TotalScoreWidget extends StatelessWidget {
  const TotalScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TeamTotalScoreWidget(
          score: 0.toString(),
          backgroundColor: Colors.red,
          teamName: 'Red',
        ),
        TeamTotalScoreWidget(
          score: 1.toString(),
          backgroundColor: Colors.yellow,
          teamName: 'Yellow',
        ),
      ],
    );
  }
}

class TeamTotalScoreWidget extends StatelessWidget {
  const TeamTotalScoreWidget({
    required this.teamName,
    required this.score,
    required this.backgroundColor,
    super.key,
  });

  final String score;
  final Color backgroundColor;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final teamTotalScoreContainerWidth = screenWidth / 2;

    return Container(
      color: backgroundColor,
      width: teamTotalScoreContainerWidth,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          Expanded(
            child: FittedBox(
              child: Text(
                score,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameInfoWidget extends StatelessWidget {
  const GameInfoWidget({
    required this.end,
    required this.gameTime,
    super.key,
  });

  final String end;
  final String gameTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.gameInfoEndLabel(end),
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 16),
        /*Text(
          AppLocalizations.of(context)!.gameInfoGameTimeLabel(gameTime),
          style: const TextStyle(fontSize: 24),
        ),*/
        TimerText(),
      ],
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration =
        context.select((ScoreboardBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text('$minutesStr:$secondsStr',
        style: const TextStyle(fontSize: 24));
  }
}

class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(flex: 1, child: Text('Ends')),
        Flexible(flex: 2, child: Text('Red Score')),
        Flexible(flex: 2, child: Text('Yellow Score')),
        //const ScoreboardButtons(),
      ],
    );
  }
}
