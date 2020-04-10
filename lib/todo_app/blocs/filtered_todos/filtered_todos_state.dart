import 'package:equatable/equatable.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();

  @override
  List<Object> get props => [];
}

class FilteredTodosLoadInProgress extends FilteredTodosState {}

class FilteredTodosLoaded extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  const FilteredTodosLoaded(this.filteredTodos, this.activeFilter);

  @override
  List<Object> get props => [filteredTodos, activeFilter];
}
