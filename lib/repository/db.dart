import 'dart:io';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:homg_long/repository/model/InAppUser.dart';

final String _tableName = 'homebody';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'homebody.db');
    print("[database] initialize(path=$path)");

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, image TEXT, ssid TEXT, bssid TEXT, timeInfo INTEGER)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  setUser(InAppUser user) async {
    final db = await database;
    var res = await db.insert(_tableName, user.getUser());
    var id = user.id;
    print("[database] set user($id):$res");
    return res;
  }

  getUser() async {
    final db = await database;
    var res = await db.query(_tableName);
    InAppUser _user = InAppUser();
    _user.setUser(res.first);
    var id = _user.id;
    print("[database] get user(id:$id)");
    return res;
  }

  deleteUser() async {
    final db = await database;
    var res = db.delete(_tableName);
    print("[database] delete user:"+res.toString());
    return res;
  }

}
