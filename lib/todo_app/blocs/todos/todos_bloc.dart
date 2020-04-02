import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/todos/todos_event.dart';
import 'package:flutter_playground/todo_app/blocs/todos/todos_state.dart';
import 'package:flutter_playground/todo_app/models/models.dart';
import 'package:flutter_playground/todo_app/repository/todos_repository.dart';
import 'package:meta/meta.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository todosRepository;

  TodosBloc({@required this.todosRepository});

  @override
  TodosState get initialState => TodosLoadInProgress();

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is TodosLoaded) {
      yield* _mapTodosLoadedToState();
    } else if (event is TodoAdded) {
      yield* _mapTodoAddedToState(event);
    } else if (event is TodoDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is TodoUpdated) {
      yield* _mapTodoUpdatedToState(event);
    }
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    try {
      final todos = await this.todosRepository.getTodos();
      yield TodosLoadSuccess(todos);
    } catch (_) {
      yield TodosLoadFailure();
    }
  }

  Stream<TodosState> _mapTodoAddedToState(TodoAdded event) async* {
    if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos =
          List.from((state as TodosLoadSuccess).todos)..add(event.todo);
      yield TodosLoadSuccess(updatedTodos);
      //  _saveTodos(updatedTodos);
      _saveTodos(event.todo);
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos =
          (state as TodosLoadSuccess).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodosLoadSuccess(updatedTodos);
      _updateTodo(event.todo);
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
    if (state is TodosLoadSuccess) {
      final updatedTodos = (state as TodosLoadSuccess)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      todosRepository.deleteTodo(event.todo);
      yield TodosLoadSuccess(updatedTodos);
      _deleteTodo(event.todo);
      //_saveTodos(updatedTodos);

    }
  }

  Future _saveTodos(Todo todos) {
    return todosRepository.addNewTodo(todos);
    /*   return todosRepository.addNewTodo(
      todos.map((todo) => todo.toEntity()).toList(),
    ); */
  }

  Future _updateTodo(Todo todo) => todosRepository.updateTodo(todo);

  Future _deleteTodo(Todo todo) => todosRepository.deleteTodo(todo);
}
