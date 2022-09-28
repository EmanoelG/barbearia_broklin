import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  //static Database _db ;
  static late Database _db;
  Future<Database> get db async {
    // if (_verificaExistencia == true) {
    //   print('_db>> $_db');
    //   return _db;
    // }

    _db = await _getDatabasess();
    return _db;
  }

  Future<Database> _getDatabasess() async {
    return openDatabase(
      join(await getDatabasesPath(), 'agendados.db'),
      onCreate: (db, version) async {
        String s = await rootBundle.loadString("assests/sql/create_sql");
        return db.execute(s);
      },
      version: 1,
    );
  }

  Future<dynamic> _getDatabase() async {
    Database _dbs;
    _dbs = await openDatabase(
      join(await getDatabasesPath(), 'agendados.db'),
      onCreate: (db, version) async {
        String s = await rootBundle.loadString("assests/sql/create_sql");
        print(s);
        return db.execute(s);
      },
      version: 1,
      onUpgrade: _onUpgrade,
    );
    return _dbs;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'agendados.db');
    print("db $path");

    var db = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    try {
      //C:\Flutter Project\list_car\assets\sql\create_sql
      String s = await rootBundle.loadString("assests/sql/create_sql");
      List<String> listS = s.split(';');
      await db.execute(s);
      // listS.forEach(
      //   (script) async {
      //     print('ASSEST SCRIPT $script');
      //     if (script.isNotEmpty) {
      //       await db.execute(script);
      //     }
      //   },
      // );
      print('Criou table: ' + s);
    } on Exception catch (e) {
      print('Erro ao criar database: $e');
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if (oldVersion == 1 && newVersion == 2) {
      await db.execute("alter table carro add column NOVA TEXT");
    }
  }

  Future close() async {
    var dbClient = await db;

    return dbClient.close();
  }
}
