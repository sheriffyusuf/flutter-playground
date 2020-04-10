import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_playground/todo_app/blocs/blocs.dart';
import 'package:flutter_playground/todo_app/models/models.dart';
import 'package:flutter_playground/todo_app/models/todo.dart';
import 'package:flutter_playground/todo_app/screens/filtered_todos_screen.dart';
import 'package:flutter_playground/todo_app/screens/stats_screen.dart';
import 'package:flutter_playground/todo_app/screens/todo_item.dart';
import 'package:flutter_playground/todo_app/widgets/filter_button.dart';
import 'package:flutter_playground/todo_app/widgets/tab_selector.dart';

final _key = GlobalKey<ScaffoldState>();

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    //  var todos = BlocProvider.of<>(context);
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return NeumorphicTheme(
        theme: NeumorphicThemeData(
            baseColor: Colors.white.withOpacity(0.3),
            variantColor: Colors.green),
        child: Scaffold(
            key: _key,
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Text("Todo App"),
              actions: <Widget>[
                FilterButton(visible: activeTab == AppTab.todos)
              ],
            ),
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
            bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
            ),

            /*  FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => Navigator.pushNamed(context, '/addTodo')), */
            body: activeTab == AppTab.todos
                ? FilteredTodosScreen()
                : StatsScreen()),
      );
    });
  }
}

Widget _todoScreen() {
  return BlocBuilder<TodosBloc, TodosState>(
    builder: (context, state) {
      if (state is TodosLoadInProgress) {
        return Center(child: CircularProgressIndicator());
      } else if (state is TodosLoadSuccess) {
        var todos = state.todos;
        return todos.isEmpty
            ? Center(child: Text("No Todos Added yet"))
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                itemCount: todos.length,
                itemBuilder: (context, position) {
                  final todo = todos[position];
                  return TodoItem(
                    todo: todo,
                    onDismissed: (direction) {
                      final deletedTodoItem = todo;
                      BlocProvider.of<TodosBloc>(context)
                          .add(TodoDeleted(deletedTodoItem));
                      //     Scaffold.of(context)
                      _key.currentState
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
                      BlocProvider.of<TodosBloc>(context).add(TodoUpdated(
                          todo.copyWith(isComplete: !todo.isComplete)));
                    },
                  );
                });
      } else {
        return Container();
      }
    },
  );
}
