import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<dynamic> onCheckboxChanged;
  const TodoItem(
      {Key key,
      @required this.todo,
      @required this.onDismissed,
      @required this.onCheckboxChanged,
      this.onTap})
      : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext mainContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Neumorphic(
        padding: EdgeInsets.symmetric(vertical: 4),
        boxShape: NeumorphicBoxShape.roundRect(
            //     borderRadius: BorderRadius.circular(8)
            ),
        style: NeumorphicStyle(
          //come back here if you need to modify the brigtheness of the checkbox
          shape: NeumorphicShape.convex,
          depth: todo.isComplete ? -1 : 8,
          lightSource: LightSource.topLeft,
          color: Colors.white,
          //    color: Colors.grey
        ),
        child: Dismissible(
          key: Key(todo.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: onDismissed,
          child: ListTile(
              leading: Container(
                alignment: Alignment.center,
                width: 45,
                height: 45,
                color: Colors.transparent,
                child: NeumorphicCheckbox(
                    style: NeumorphicCheckboxStyle(
                      selectedDepth: 5,
                      //   selectedColor: Colors.blue,
                      unselectedDepth: 0,
                    ),
                    value: todo.isComplete,
                    onChanged: onCheckboxChanged),
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                    decoration:
                        todo.isComplete ? TextDecoration.lineThrough : null),
              )),
        ),
      ),
    );
  }
}
