import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/stats/stats.dart';
import 'package:flutter_playground/todo_app/blocs/todos/todos.dart';
import 'package:meta/meta.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  StatsBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoadSuccess) {
        add(StatsUpdated(state.todos));
      }
    });
  }

  @override
  StatsState get initialState => StatsLoadInProgress();

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is StatsUpdated) {
      yield* _mapStatsUpdatedToState(event);
    }
  }

  Stream<StatsState> _mapStatsUpdatedToState(StatsUpdated event) async* {
    int numActive =
        event.todos.where((todo) => !todo.isComplete).toList().length;
    int numCompleted =
        event.todos.where((todo) => todo.isComplete).toList().length;

    yield StatsLoaded(numActive, numCompleted);
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
