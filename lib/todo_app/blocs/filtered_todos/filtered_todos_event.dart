import 'package:equatable/equatable.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class FilterUpdated extends FilteredTodosEvent {
  final VisibilityFilter filter;

  const FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];
}

class UpdateTodos extends FilteredTodosEvent {
  final List<Todo> todos;

  const UpdateTodos(this.todos);

  @override
  List<Object> get props => [todos];
}
