import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isComplete;

  TodoEntity(this.id, this.title, this.description, this.isComplete);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isComplete": isComplete == false ? 0 : 1
    };
  }

  @override
  List<Object> get props => [isComplete, id, title, description];

  @override
  String toString() {
    return 'TodoEntity { complete: $isComplete, title: $title, description: $description, id: $id }';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json["id"] as int,
      json["title"] as String,
      json["description"] as String,
      json["isComplete"] == 0 ? false : true,
    );
  }
}
