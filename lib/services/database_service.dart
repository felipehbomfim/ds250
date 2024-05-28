import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = 'ds250.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion);
  }

  Future<void> createTaskTable() async {
    Database db = await instance.database;
    await db.execute('''
         CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            descricao TEXT NOT NULL,
            hora_inicio TEXT NULL,
            hora_fim INT NOT NULL,
            prioridade TEXT NULL,
            alerta TEXT NULL,
            concluido BOOL NOT NULL, 
            data DATETIME
          )
      ''');
  }

  Future<void> registerTask(Map<String, dynamic> data) async {
    Database db = await instance.database;
    await db.insert(
      'tasks',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchTasks({String? date, String? busca, int? limit}) async {
    Database db = await instance.database;

    // Comece com a consulta base que busca todos os registros.
    String sql = 'SELECT tasks.* FROM tasks';
    List<dynamic> arguments = [];

    bool whereAdded = false; // Para controlar a adição de cláusulas WHERE

    if (date != null) {
      if (!whereAdded) {
        sql += ' WHERE';
        whereAdded = true;
      } else {
        sql += ' AND';
      }
      sql += ' date(tasks.data) = date(?)';
      arguments.add(date);
    }

    if (busca != null) {
      if (!whereAdded) {
        sql += ' WHERE';
        whereAdded = true;
      } else {
        sql += ' AND';
      }
      sql += ' tasks.nome LIKE ?';
      arguments.add('%' + busca + '%');
    }

    if (limit != null) {
      sql += ' ORDER BY concluido ASC LIMIT ?';
      arguments.add(limit);
    }
    return await db.rawQuery(sql, arguments.isEmpty ? null : arguments);
  }

  Future<void> updateTaskAsCompleted(int taskId) async {
    Database db = await instance.database;
    String sql = 'UPDATE tasks SET concluido = 1 WHERE id = ?';
    await db.rawUpdate(sql, [taskId]);
  }

  Future<void> updateTask(int taskId, Map<String, dynamic> newData) async {
    Database db = await instance.database;
    await db.update(
      'tasks',
      newData,
      where: 'id = ?',
      whereArgs: [taskId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(int taskId) async {
    Database db = await instance.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

}