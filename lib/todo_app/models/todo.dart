import 'package:flutter_playground/todo_app/entities/entities.dart';
import 'package:meta/meta.dart';

@immutable
class Todo {
  final int id;
  final String title;
  final String description;
  final bool isComplete;

  //Todo(this.id, this.title, this.description, this.isComplete);

  Todo(this.title, {this.isComplete = false, String description = '', int id})
      : this.description = description ?? '',
        this.id = id;

  Todo copyWith(
      {bool isComplete, String id, String description, String title}) {
    return Todo(
      title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode =>
      isComplete.hashCode ^ title.hashCode ^ description.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          isComplete == other.isComplete &&
          title == other.title &&
          description == other.description &&
          id == other.id;

  @override
  String toString() {
    return 'Todo { complete: $isComplete, title: $title, description: $description, id: $id }';
  }

  TodoEntity toEntity() {
    return TodoEntity(id, title, description, isComplete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.title,
      isComplete: entity.isComplete ?? false,
      description: entity.description,
      id: entity.id,
    );
  }
}
