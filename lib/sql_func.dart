// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlFunctions {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDatabase();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bilal.db');
    Database myDatabase = await openDatabase(path,
        onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1);
    return myDatabase;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "note" TEXT NOT NULL,
        "color" TEXT NOT NULL
      )
''');

    print('OnCreate Successfully');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('ALTER TABLE notes ADD COLUMN columnTitle TEXT');
    print('OnUpgrade Successfully');
  }

  Future<List<Map<String, Object?>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  deleteDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bilal.db');
    await deleteDatabase(path);
  }
}
