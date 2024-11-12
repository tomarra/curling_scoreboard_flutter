part of 'scoreboard_bloc.dart';

sealed class ScoreboardState extends Equatable {
  const ScoreboardState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];
}

final class ScoreboardInitial extends ScoreboardState {
  const ScoreboardInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

final class ScoreboardInProgress extends ScoreboardState {
  const ScoreboardInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}
