import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:curling_scoreboard_flutter/scoreboard/ticker.dart';
import 'package:equatable/equatable.dart';

part 'scoreboard_event.dart';
part 'scoreboard_state.dart';

class ScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const ScoreboardInitial(_duration)) {
    on<ScoreboardStarted>(_onStarted);
    on<ScoreboardReset>(_onReset);
    on<_ScoreboardTimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  static const int _duration = 1;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(ScoreboardStarted event, Emitter<ScoreboardState> emit) {
    emit(ScoreboardInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_ScoreboardTimerTicked(duration: duration)));
  }

  void _onReset(ScoreboardReset event, Emitter<ScoreboardState> emit) {
    _tickerSubscription?.cancel();
    emit(const ScoreboardInitial(_duration));
  }

  void _onTicked(_ScoreboardTimerTicked event, Emitter<ScoreboardState> emit) {
    emit(ScoreboardInProgress(event.duration));
  }
}
