import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/blocs.dart';
import 'package:flutter_playground/todo_app/screens/delete_todo_snack_bar.dart';
import 'package:flutter_playground/todo_app/screens/todo_item.dart';

class FilteredTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        if (state is FilteredTodosLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FilteredTodosLoaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoItem(
                    todo: todo,
                    onDismissed: (direction) {
                      BlocProvider.of<TodosBloc>(context)
                          .add(TodoDeleted(todo));
                      Scaffold.of(context).showSnackBar(
                        DeleteTodoSnackBar(
                          key: Key("Snackbarrrrr"),
                          todo: todo,
                          onUndo: () => BlocProvider.of<TodosBloc>(context).add(
                            TodoAdded(todo),
                          ),
                        ),
                      );
                    },
                    onCheckboxChanged: (_) {
                      BlocProvider.of<TodosBloc>(context).add(
                        TodoUpdated(
                          todo.copyWith(isComplete: !todo.isComplete),
                        ),
                      );
                    });
              });
        } else {
          return Container();
        }
      },
    );
  }
}
