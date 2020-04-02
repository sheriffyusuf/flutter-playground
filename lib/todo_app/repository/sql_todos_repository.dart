import 'dart:io';

import 'package:flutter_playground/todo_app/entities/entities.dart';
import 'package:flutter_playground/todo_app/models/todo.dart';
import 'package:flutter_playground/todo_app/repository/todos_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlTodosRepository extends TodosRepository {
  SqlTodosRepository._();

  static final SqlTodosRepository db = SqlTodosRepository._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await _initDb();
    return _database;
  }

  static const dbFileName = 'todos.db';

  //Columns
  static const todoTable = 'todos_tbl';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';
  final String columnisComplete = 'isComplete';

  Database _db;
  //AsyncMemoizer _memoizer = AsyncMemoizer();
/*   SqlTodosRepository() {
    _initDb();
  } */

  _initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, dbFileName);
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
  Stream<List<Todo>> todos() {
    _db.query(todoTable);
    return null;
    // return Stream.fromFuture(_db.query(todoTable)).map((json) => Todo.fromEntity(TodoEntity.fromJson(json))).toList();
    //  return null;
  }

  @override
  Future<List<Todo>> getTodos() async {
    final db = await database;
    return (await db.query(todoTable))
        .map((json) => Todo.fromEntity(TodoEntity.fromJson(json)))
        .toList();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(todoTable, todo.toEntity().toJson(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }
}
