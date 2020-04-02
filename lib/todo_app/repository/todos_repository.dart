import 'dart:async';

import 'package:flutter_playground/todo_app/models/models.dart';

abstract class TodosRepository {
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);

  Stream<List<Todo>> todos();

  Future<List<Todo>> getTodos();

  Future<void> updateTodo(Todo todo);
}
