import 'package:flutter/material.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar({
    Key key,
    @required Todo todo,
    @required VoidCallback onUndo,
  }) : super(
            key: key,
            content: Text(
              "Deleted todo with id ${todo.id}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            duration: Duration(seconds: 2),
            action: SnackBarAction(label: "undo", onPressed: onUndo));
}
