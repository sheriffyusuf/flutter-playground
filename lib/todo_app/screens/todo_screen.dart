import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_playground/todo_app/blocs/todos/bloc.dart';
import 'package:flutter_playground/todo_app/models/todo.dart';

final _key = GlobalKey<ScaffoldState>();

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    //  var todos = BlocProvider.of<>(context);
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          baseColor: Colors.white.withOpacity(0.3), variantColor: Colors.green),
      child: Scaffold(
          key: _key,
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(title: Text("Todo App")),
          floatingActionButton: Neumorphic(
            boxShape: NeumorphicBoxShape.circle(),
            style: NeumorphicStyle(
                lightSource: LightSource.top,
                shape: NeumorphicShape.convex,
                color: Colors.blue,
                depth: 5),
            child: Container(
              width: 60,
              height: 60,
              child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/addTodo'),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            ),
          ),

          /*  FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, '/addTodo')), */
          body: BlocBuilder<TodosBloc, TodosState>(
            builder: (context, state) {
              if (state is TodosLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TodosLoadSuccess) {
                var todos = state.todos;
                return todos.isEmpty
                    ? Center(child: Text("No Todos Added yet"))
                    : ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        itemCount: todos.length,
                        itemBuilder: (context, position) {
                          final todo = todos[position];
                          return TodoItem(
                            todo: todo,
                            onDismissed: (direction) {
                              final deletedTodoItem = todo;
                              BlocProvider.of<TodosBloc>(context)
                                  .add(TodoDeleted(deletedTodoItem));
                              Scaffold.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                    content: Row(
                                  children: <Widget>[
                                    Text("Todo has been deleted"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          BlocProvider.of<TodosBloc>(context)
                                              .add(TodoAdded(deletedTodoItem));
                                        },
                                        child: Text(
                                          "undo",
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                  ],
                                )));
                            },
                            onCheckboxChanged: (value) {
                              BlocProvider.of<TodosBloc>(context).add(
                                  TodoUpdated(todo.copyWith(
                                      isComplete: !todo.isComplete)));
                            },
                          );
                        });
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

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
          key: Key(todo.title),
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
