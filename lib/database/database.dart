import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final _dbName = 'db_events';
  static final _dbVersion = 1;
  static final table = 'events';
  static final columnId = 'id';
  static final columnDate = 'date';
  static final columnEvents = 'event';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initialDatabase();
    return _database;
  }

  Future<Database> _initialDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute("""
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY,
        $columnEvents TEXT,
        $columnDate TEXT
      )
      """);
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  update(int id, Map<String, dynamic> row) async {
    Database? db = await instance.database;

    return db!.update(table, row, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  delete(int id) async {
    Database? db = await instance.database;
    return db!.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }
}
