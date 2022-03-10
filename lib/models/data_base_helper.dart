import 'package:my_tasks/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  final String tableTodo = 'todo';
  final String colId = 'id';
  final String colTitle = 'title';
  final String colDescription = 'description';
  final String colDate = 'time';

  Future open(String path) async {
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
CREATE TABLE $tableTodo ( 
  $colId integer primary key autoincrement, 
  $colTitle text not null,
  $colDescription text not null,
  $colDate integer not null)
''');
        });
  }

  Future<Task> insert(Task todo) async {
    todo.id = await _db?.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Task?> getTask(int id) async {
    List<Map<String, Object?>> maps = await _db!.query(tableTodo,
        columns: [colId, colTitle, colDescription, colDate],
        where: '$colId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, Object?>>?> getTaskMapList() async {
    final List<Map<String, Object?>>? result = await _db?.query(tableTodo);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, Object?>>? taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList?.forEach((element) {
      taskList.add(Task.fromMap(element));
    });
    return taskList;
  }

  Future<int?> delete(int id) async {
    return await _db?.delete(tableTodo, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int?> update(Task todo) async {
    return await _db?.update(tableTodo, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
  }

  Future close() async => _db?.close();
}