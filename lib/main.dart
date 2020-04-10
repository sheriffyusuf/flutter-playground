import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/blocs.dart';
import 'package:flutter_playground/todo_app/models/models.dart';
import 'package:flutter_playground/todo_app/repository/sqlbrite_todos_repository.dart';
import 'package:flutter_playground/todo_app/screens/add_todo_screen.dart';
import 'package:flutter_playground/todo_app/screens/todo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosBloc>(
      create: (context) =>
          TodosBloc(todosRepository: SqlBriteTodosRepository.db)
            ..add(TodosLoaded()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TabBloc>(create: (context) => TabBloc()),
          BlocProvider<FilteredTodosBloc>(
            create: (context) => FilteredTodosBloc(
                todosBloc: BlocProvider.of<TodosBloc>(context)),
          ),
          BlocProvider<StatsBloc>(
            create: (context) => StatsBloc(
              todosBloc: BlocProvider.of<TodosBloc>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (context) => TodoScreen(),
            '/addTodo': (context) => AddTodoScreen(
                  onSave: (title, description) {
                    BlocProvider.of<TodosBloc>(context).add(
                      TodoAdded(Todo(title, description: description)),
                    );
                  },
                )
          },
          //  home: TodoScreen()
          /*BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(),
              child: MyHomePage(title: 'Flutter Demo Home Page')),*/
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times',
            ),
            BlocBuilder(
              bloc: BlocProvider.of<CounterBloc>(context),
              builder: (context, value) => Text(
                '$value',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counterBloc.add(CounterEvent.Increment),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

enum CounterEvent { Increment, Decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.Increment:
        yield state + 1;
        break;
      case CounterEvent.Decrement:
        yield state - 1;
        break;
    }
  }
}
