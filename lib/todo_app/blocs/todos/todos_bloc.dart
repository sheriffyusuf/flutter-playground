import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/todos/todos_event.dart';
import 'package:flutter_playground/todo_app/blocs/todos/todos_state.dart';
import 'package:flutter_playground/todo_app/models/models.dart';
import 'package:flutter_playground/todo_app/repository/todos_repository.dart';
import 'package:meta/meta.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  StreamSubscription _todosSubscription;

  TodosBloc({@required TodosRepository todosRepository})
      : assert(todosRepository != null),
        _todosRepository = todosRepository;

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
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdateToState(event);
    }
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    _todosSubscription?.cancel();
    _todosSubscription =
        _todosRepository.todos().listen((todos) => add(TodosUpdated(todos)));
    /*  try {
      final todos = await this.todosRepository.getTodos();
      yield TodosLoadSuccess(todos);
    } catch (_) {
      yield TodosLoadFailure();
    } */
  }

  Stream<TodosState> _mapTodoAddedToState(TodoAdded event) async* {
    _todosRepository.addNewTodo(event.todo);
    /*  if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos =
          List.from((state as TodosLoadSuccess).todos)..add(event.todo);
      yield TodosLoadSuccess(updatedTodos);
      //  _saveTodos(updatedTodos);
      _saveTodos(event.todo);
    } */
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    _todosRepository.updateTodo(event.todo);
    /*    if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos =
          (state as TodosLoadSuccess).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodosLoadSuccess(updatedTodos);
      _updateTodo(event.todo);
    } */
  }

  Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
    _todosRepository.deleteTodo(event.todo);
    /*   if (state is TodosLoadSuccess) {
      final updatedTodos = (state as TodosLoadSuccess)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      todosRepository.deleteTodo(event.todo);
      yield TodosLoadSuccess(updatedTodos);
      _deleteTodo(event.todo);
      //_saveTodos(updatedTodos);

    } */
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoadSuccess(event.todos);
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
  /*  Future _saveTodos(Todo todos) {
    return todosRepository.addNewTodo(todos);
    /*   return todosRepository.addNewTodo(
      todos.map((todo) => todo.toEntity()).toList(),
    ); */
  }

  Future _updateTodo(Todo todo) => todosRepository.updateTodo(todo);

  Future _deleteTodo(Todo todo) => todosRepository.deleteTodo(todo); */
}
