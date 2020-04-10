import 'package:flutter_playground/todo_app/entities/entities.dart';
import 'package:flutter_playground/todo_app/models/todo.dart';
import 'package:flutter_playground/todo_app/repository/todos_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';

class SqlBriteTodosRepository extends TodosRepository {
  SqlBriteTodosRepository._();

  static final SqlBriteTodosRepository db = SqlBriteTodosRepository._();

  static BriteDatabase _briteDatabase;

  Future<BriteDatabase> get database async {
    if (_briteDatabase != null) return _briteDatabase;
    // if _britDatabase is null we instantiate it
    _briteDatabase = BriteDatabase(await _initDb());
    return _briteDatabase;
  }

  //Columns
  static const todoTable = 'todos_tbl';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';
  final String columnisComplete = 'isComplete';

  Future<Database> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'todos.db');

    return await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $todoTable( 
            $columnId INTEGER PRIMARY KEY, 
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnisComplete INTEGER NOT NULL)
          ''');
    });
  }

  @override
  Future<void> addNewTodo(Todo todo) async {
    final db = await database;
    return await db.insert(todoTable, todo.toEntity().toJson());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    final db = await database;
    return await db
        .delete(todoTable, where: '$columnId = ?', whereArgs: [todo.id]);
  }

  @override
  Future<List<Todo>> getTodos() {
    return null;
  }

  @override
  Stream<List<Todo>> todos() async* {
    final db = await database;
    yield* db
        .createQuery(todoTable)
        .mapToList((json) => Todo.fromEntity(TodoEntity.fromJson(json)));
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(todoTable, todo.toEntity().toJson(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }
}
