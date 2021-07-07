import 'dart:convert';

import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  final String _userInfoTable = 'userinfo';
  final String _timeInfoTable = 'timeinfo';
  final String _DBPath = 'homebody.db';

  final logUtil = LogUtil();
  final log = Logger("DBHelper");

  static final DBHelper _instance = DBHelper._internal();
  DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  static Database _database;

  Future<Database> get getDatabase async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    log.info("initDB");

    String path = join(await getDatabasesPath(), _DBPath);
    log.info("database initialize(path=$path)");

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        create table $_userInfoTable(id TEXT PRIMARY KEY, name TEXT, image TEXT, ssid TEXT, bssid TEXT, week TEXT, timeInfo TEXT, street TEXT, latitude REAL, longitude REAL)
        ''');
      await db.execute('''
          CREATE TABLE $_timeInfoTable(date TEXT PRIMARY KEY, timeList TEXT)
          ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  Future<bool> setUserInfo(UserInfo userInfo) async {
    log.info("setUserInfo($userInfo)");
    final database = await getDatabase;

    log.info("userInfo.getUser():${userInfo.toJson()}");
    // data will be replaced if DB already has same column.
    var res = await database.insert(_userInfoTable, userInfo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (res == 1) {
      log.info("setUserInfo success(id:${userInfo.id})");
      return true;
    }

    log.info("setUserInfo fail(id:${userInfo.id})");
    return false;
  }

  // initialize InAppUser when app is starting.
  // so don't need to call getUser() function when app running.
  Future<UserInfo> getUserInfo() async {
    log.info("getUserInfo");
    final db = await getDatabase;
    UserInfo userInfo = UserInfo();

    var res = await db.query(_userInfoTable);
    if (res.length == 0) {
      log.info("getUser fail(table($_userInfoTable) is empty)");
      return null;
    }

    // update InAppUser info. for synchronous function.
    userInfo.fromJson(res.first);

    log.info("getUser success(${userInfo.toJson()})");
    return userInfo;
  }

  Future<bool> deleteUserInfo() async {
    log.info("deleteUserInfo");
    final db = await getDatabase;
    UserInfo userInfo = await getUserInfo();
    if (userInfo == null) {
      log.info("table($_userInfoTable) is already empty");
      return true;
    }

    var res =
        db.delete(_userInfoTable, where: "id = ?", whereArgs: [userInfo.id]);
    res.then((value) {
      if (value == 1) {
        log.info("deleteUser success(id:${userInfo.id})");
        return true;
      } else {
        log.info("deleteUser fail(id:${userInfo.id}):$value");
        return false;
      }
    }).catchError((error) {
      logUtil.logger.e("deleteUser error(id:${userInfo.id}):$error");
      return false;
    });

    return false;
  }

  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    log.info("updateLocationInfo");
    final db = await getDatabase;
    UserInfo userInfo = await getUserInfo();
    userInfo.latitude = latitude;
    userInfo.longitude = longitude;
    userInfo.street = street;

    var res = db.update(_userInfoTable, userInfo.toJson(),
        where: "id = ?", whereArgs: [userInfo.id]);
    res.then((value) {
      if (value == 1) {
        log.info("updateLocation success(id:${userInfo.id}):$userInfo");
        return true;
      } else {
        log.info("updateLocation fail(id:${userInfo.id}):$value");
        return false;
      }
    }).catchError((error) {
      logUtil.logger.e("updateLocation error(id:${userInfo.id}):$error");
      return false;
    });

    return false;
  }

  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    log.info("updateWifiInfo");
    final db = await getDatabase;
    UserInfo userInfo = await getUserInfo();
    userInfo.ssid = ssid;
    userInfo.bssid = bssid;

    var res = db.update(_userInfoTable, userInfo.toJson(),
        where: "id = ?", whereArgs: [userInfo.id]);
    res.then((value) {
      if (value == 1) {
        log.info("updateWifiInfo success(id:${userInfo.id}):$userInfo");
        return true;
      } else {
        log.info("updateWifiInfo fail(id:${userInfo.id}):$value");
        return false;
      }
    }).catchError((error) {
      logUtil.logger.e("updateWifiInfo error(id:${userInfo.id}):$error");
      return false;
    });

    return false;
  }

  Future<bool> setTimeData(TimeData timeData) async {
    log.info("setTimeInfo");
    final db = await getDatabase;

    Map<String, String> timeDataMap = {
      getDay(DateTime.now()).toString(): jsonEncode(timeData)
    };

    log.info("timeData.toJson()=${timeData.toJson()}");
    log.info("jsonEncode(timeData)=${jsonEncode(timeData)}");

    var res = await db.rawInsert(
        'INSERT INTO $_timeInfoTable(date, timeList) VALUES (?, ?)',
        [getDay(DateTime.now()).toString(), jsonEncode(timeData)]);
    if (res == 1) {
      log.info("setTimeInfo success");
      return true;
    }

    log.info("setTimeInfo failed");
    return false;
  }

  Future<TimeData> getTimeData(int date) async {
    log.info("getTimeInfo");
    var db = await getDatabase;

    TimeData _timeData = TimeData();

    var res =
        await db.query(_timeInfoTable, where: 'date = ?', whereArgs: [date]);
    if (res.isEmpty) {
      log.info("getTimeInfo fail(date:$date):has no timeInfo");
      return null;
    }

    log.info("res.first=${res.first}");
    log.info("res.first['date']=${res.first['date']}");
    log.info("res.first['timeList']=${res.first['timeList']}");
    var tagsJson = jsonDecode(res.first['timeList']);
    log.info(
        "jsonDecode(res.first['timeList'])=${jsonDecode(res.first['timeList'])}");

    List<Map<String, dynamic>> tags =
        tagsJson != null ? List.from(tagsJson) : null;
    // List<Time> timeDatas = res.first[date.toString()];
    log.info("getTimeInfo success(date:$date)");

    _timeData.fromJson(tags);
    log.info("timeData.toJson()=${_timeData.toJson()}");
    return _timeData;
  }
}
