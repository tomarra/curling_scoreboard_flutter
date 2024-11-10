import 'package:bloc/bloc.dart';

class ScoreboardCubit extends Cubit<int> {
  ScoreboardCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
