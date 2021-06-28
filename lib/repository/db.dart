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

  Future<Database> initDB() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, 'homebody.db');

    String path = join(await getDatabasesPath(), 'homebody.db');
    logUtil.logger.d("database initialize(path=$path)");
    // DB Version Must be updated if the table has been changed.
    // await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, image TEXT, ssid TEXT, bssid TEXT, timeInfo TEXT, latitude REAL, longitude REAL)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  setUser(InAppUser user) async {
    final db = await database;
    return await db.insert(_tableName, user.getUser(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<InAppUser> getUser() async {
    final db = await database;
    InAppUser _user = InAppUser();
    var res = await db.query(_tableName);
    if (res.length == 0) {
      logUtil.logger.e("[database] table($_tableName) has null");
      return null;
    }
    logUtil.logger.d("getUser():$res");
    _user.setUser(res.first);
    return _user;
  }

  deleteUser() async {
    final db = await database;
    InAppUser _user = InAppUser();
    var res = db.delete(_tableName, where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      // success to delete user.
    }).catchError((error) {
      logUtil.logger.e("[database] delete user fail($error)");
    });

    // var dropRes = db.execute("DROP TABLE $_tableName");
    // logUtil.logger.d("drop table($dropRes)");

    return res;
  }

  updateLastTimeStamp(String timeStamp) async {
    final db = await database;
    InAppUser _user = InAppUser();
    var res = db.update(_tableName, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      // success to update time info.
    }).catchError((error) {
      logUtil.logger.d("[database] update time info fail:$error");
    });
  }

  updateTimeInfo(String timeInfo) async {
    final db = await database;
    InAppUser _user = InAppUser();
    _user.timeInfo = timeInfo;
    var res = db.update(_tableName, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      // success to update time info.
    }).catchError((error) {
      logUtil.logger.d("[database] update time info fail:$error");
    });
  }

  updateLocation(double latitude, double longitude) async {
    final db = await database;
    InAppUser _user = InAppUser();
    _user.latitude = latitude;
    _user.longitude = longitude;
    var res = db.update(_tableName, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      // success to update location info.
    }).catchError((error) {
      logUtil.logger.d("[database] update location fail:$error");
    });
  }

  updateWifiInfo(String ssid, String bssid) async {
    final db = await database;
    InAppUser _user = InAppUser();
    _user.ssid = ssid;
    _user.bssid = bssid;
    var res = db.update(_tableName, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      // success to update wifi info.
    }).catchError((error) {
      logUtil.logger.d("[database] update wifi info fail:$error");
    });
  }

  int getTotalTime(DateTime dateTime) {
    return 10;
  }

  void saveTime(DateTime dateTime) {}
}
