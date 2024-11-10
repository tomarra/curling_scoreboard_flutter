import 'package:curling_scoreboard_flutter/l10n/l10n.dart';
import 'package:curling_scoreboard_flutter/scoreboard/scoreboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoreboardCubit(),
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
      body: const Center(child: ScoreboardText()),
      floatingActionButton: Column(
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
      ),
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
        //buildResetButton(context),
        //buildAddScoreButton(context),
        //buildSettingsButton(context),
      ],
    );
  }
}

class ScoreboardText extends StatelessWidget {
  const ScoreboardText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((ScoreboardCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
