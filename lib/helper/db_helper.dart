import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();

    return _db;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'verzel.db');
    print("db $path");
//    await deleteDatabase(path);
    var db = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    print('ENTREI NO ONCREATE');
    await db.execute(
        'CREATE TABLE usuario(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nome STRING(50), email STRING(255), dataNascimento  STRING(10), cpf STRING(14), cep STRING(8), bairro STRING(80), cidade STRING(80), estado STRING(2), endereco STRING(255), complemento STRING(100), numero STRING(10), senha STRING(255))');
    await db.execute(
        'CREATE TABLE tarefa(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, fkusuario INTEGER, descricao STRING(50), dataEntrega STRING(10), dataConclusao STRING(10))');
  }

  Future<FutureOr<void>> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if (oldVersion == 1 && newVersion == 2) {
//      await db.execute("alter table usuario add column senha STRING(255)");
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
