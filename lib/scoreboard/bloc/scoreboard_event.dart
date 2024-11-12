part of 'scoreboard_bloc.dart';

sealed class ScoreboardEvent {
  const ScoreboardEvent();
}

final class ScoreboardStarted extends ScoreboardEvent {
  const ScoreboardStarted({required this.duration});
  final int duration;
}

class ScoreboardReset extends ScoreboardEvent {
  const ScoreboardReset();
}

class _ScoreboardTimerTicked extends ScoreboardEvent {
  const _ScoreboardTimerTicked({required this.duration});
  final int duration;
}
