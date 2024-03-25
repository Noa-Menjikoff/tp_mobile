import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'BD.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scores(
        id INTEGER PRIMARY KEY,
        playerName TEXT,
        level INTEGER,
        moves INTEGER,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertScore(Score score) async {
    final db = await database;
    await db.insert('scores', score.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Score>> getScores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('scores');
    return List.generate(maps.length, (i) {
      return Score.fromMap(maps[i]);
    });
  }
}
