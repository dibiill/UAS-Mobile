import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planify.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE schedule (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        room TEXT NOT NULL,
        detail TEXT NOT NULL,
        date TEXT NOT NULL,
        color INTEGER
      )
    ''');

    await db.execute('''
  CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    scheduleId INTEGER,
    FOREIGN KEY (scheduleId) REFERENCES schedule(id)
  )
''');

    await db.execute('''
  CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      deadline TEXT NOT NULL,
      progress REAL NOT NULL,
      status TEXT NOT NULL,
      color INTEGER NOT NULL
      )
''');
  }

  // Hash password biar aman
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    final db = await instance.database;

    // Cek apakah email sudah ada
    var result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) return false; // email sudah dipakai

    await db.insert('users', {
      'name': name,
      'email': email,
      'password': _hashPassword(password),
    });
    return true;
  }

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, _hashPassword(password)],
    );

    if (result.isNotEmpty) {
      return result.first; // berisi id, name, email
    }
    return null;
  }

  // SCHEDULE CRUD
  // INSERT
  Future<int> insertSchedule(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert("schedule", data);
  }

  // GET BY DATE
  Future<List<Map<String, dynamic>>> getSchedulesByDate(String date) async {
    final db = await instance.database;
    return await db.query(
      "schedule",
      where: "date = ?",
      whereArgs: [date],
      orderBy: "time ASC",
    );
  }

  // UPDATE
  Future<int> updateSchedule(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update("schedule", data, where: "id = ?", whereArgs: [id]);
  }

  // DELETE
  Future<int> deleteSchedule(int id) async {
    final db = await instance.database;
    return await db.delete("schedule", where: "id = ?", whereArgs: [id]);
  }

  // date picker
  Future<List<String>> getAllScheduleDates() async {
    final db = await instance.database;
    final res = await db.rawQuery(
      'SELECT DISTINCT date FROM schedule ORDER BY date ASC',
    );
    return res.map((e) => e['date'] as String).toList();
  }

  // GET ALL SCHEDULES (untuk cek apakah tabel kosong)
  Future<List<Map<String, dynamic>>> getAllSchedules() async {
    final db = await instance.database;
    return await db.query("schedule");
  }

  // NOTES CRUD
  Future<int> insertNote(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert("notes", data);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await instance.database;
    return await db.query("notes", orderBy: "id DESC");
  }

  Future<int> updateNote(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update("notes", data, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }
}
