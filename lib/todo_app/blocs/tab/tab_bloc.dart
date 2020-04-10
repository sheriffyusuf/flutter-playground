import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/tab/tab_event.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.todos;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
