import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/task_model.dart';

class TaskTable {
  static const table = "tasks";

  static Future<int> insert(TaskModel t) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(table, t.toMap());
  }

  static Future<List<TaskModel>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query(table, orderBy: "id DESC");
    return data.map((e) => TaskModel.fromMap(e)).toList();
  }

  static Future<int> update(TaskModel t) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      table,
      t.toMap(),
      where: "id = ?",
      whereArgs: [t.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
