import 'dart:io';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/log/logger.dart';

final String _tableName = 'homebody';

class DBHelper {
  final logUtil = LogUtil();
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
    logUtil.logger.d("[database] initialize(path=$path)");

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, image TEXT, ssid TEXT, bssid TEXT, timeInfo TEXT, latitude REAL, longitude REAL)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  setUser(InAppUser user) async {
    logUtil.logger.d("[database] set user");
    final db = await database;
    var res = await db.insert(_tableName, user.getUser());
    var id = user.id;
    logUtil.logger.d("[database] set user result(id:$id):" + res.toString());
    return res;
  }

  getUser() async {
    logUtil.logger.d("[database] get user");
    final db = await database;
    var res = await db.query(_tableName);
    InAppUser _user = InAppUser();
    if (res.length == 0) {
      logUtil.logger.d("[datebase] $_tableName table has null");
      return;
    }
    _user.setUser(res.first);
    var id = _user.id;
    logUtil.logger.d("[database] get user result(id:$id):" + _user.toString());
  }

  deleteUser() async {
    logUtil.logger.d("[database] delete user");
    final db = await database;
    InAppUser _user = InAppUser();
    _user.setUser({});
    var res = db.update(_tableName, _user.getUser(), where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      logUtil.logger.d("[database] delete user success");
    }).catchError((error){
      logUtil.logger.e("[database] delete user fail:$error");
    });
    return res;
  }

  updateTimeInfo(String timeInfo) async {
    logUtil.logger.d("[database] update time info");
    final db = await database;
    InAppUser _user = InAppUser();
    _user.timeInfo = timeInfo;
    var res = db.update(_tableName, _user.getUser(), where: "id = ?", whereArgs: [_user.id]);
    res.then((value){
      logUtil.logger.d("[database] update time info success");
    }).catchError((error){
      logUtil.logger.d("[database] update time info fail:$error");
    });

  }

  updateLocation(double latitude, double longitude) async {
    logUtil.logger.d("[database] update location");
    final db = await database;
    InAppUser _user = InAppUser();
    _user.latitude =  latitude;
    _user.longitude = longitude;
    var res = db.update(_tableName, _user.getUser(), where: "id = ?", whereArgs: [_user.id]);
    res.then((value){
      logUtil.logger.d("[database] update location success");
    }).catchError((error){
      logUtil.logger.d("[database] update location fail:$error");
    });

  }
}
