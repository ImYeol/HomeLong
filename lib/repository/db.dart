import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String _userInfoTable = 'userinfo';
final String _timeInfoTable = 'timeinfo';

class DBHelper {
  final logUtil = LogUtil();
  final log = Logger("DBHelper");

  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    log.info("initDB");

    String path = join(await getDatabasesPath(), 'homebody.db');
    log.info("database initialize(path=$path)");

    // DB Version Must be updated if the table has been changed.
    // await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_userInfoTable(id TEXT PRIMARY KEY, name TEXT, image TEXT, ssid TEXT, bssid TEXT, week TEXT, timeInfo TEXT, street TEXT, latitude REAL, longitude REAL)');
      await db.execute(
          'CREATE TABLE $_timeInfoTable(date INTEGER PRIMARY KEY, minute INTEGER)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  Future<bool> setUserInfo(InAppUser user) async {
    log.info("setUserInfo($user)");
    final db = await database;

    // data will be replaced if DB already has same column.
    var res = await db.insert(_userInfoTable, user.getUser(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (res == 1) {
      log.info("setUserInfo success(id:${user.id})");
      InAppUser().updateUser(user);
      return true;
    }

    log.info("setUserInfo fail(id:${user.id})");
    return false;
  }

  // initialize InAppUser when app is starting.
  // so don't need to call getUser() function when app running.
  Future<InAppUser> getUserInfo() async {
    log.info("getUserInfo");
    final db = await database;
    InAppUser _user = InAppUser();

    var res = await db.query(_userInfoTable);
    if (res.length == 0) {
      log.info("getUser fail(id:${_user.id}):has no userInfo");
      return null;
    }

    // update InAppUser info. for synchronous function.
    _user.setUser(res.first);

    log.info("getUser success:${_user.getUser()}");
    return _user;
  }

  deleteUserInfo() async {
    log.info("deleteUserInfo");
    final db = await database;
    InAppUser _user = await getUserInfo();
    if (_user == null) {
      return;
    }

    var res = db.delete(_userInfoTable, where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      if (value == 1) {
        log.info("deleteUser success(id:${_user.id})");
      } else {
        log.info("deleteUser fail(id:${_user.id}):$value");
      }
    }).catchError((error) {
      logUtil.logger.e("deleteUser error(id:${_user.id}):$error");
    });

    _user.deleteUser();

    return res;
  }

  // updateTimeInfo(String timeInfo) async {
  //   log.info("updateTimeInfo");
  //   final db = await database;
  //   InAppUser _user = InAppUser();
  //   _user.timeInfo = timeInfo;
  //
  //   var res = db.update(_userInfoTable, _user.getUser(),
  //       where: "id = ?", whereArgs: [_user.id]);
  //   res.then((value) {
  //     if (value == 1) {
  //       log.info("updateTimeInfo success");
  //     } else {
  //       log.info("updateTimeInfo failed:$value");
  //     }
  //   }).catchError((error) {
  //     logUtil.logger.e("updateTimeInfo error:$error");
  //   });
  // }

  updateLocationInfo(double latitude, double longitude, String street) async {
    log.info("updateLocationInfo");
    final db = await database;
    InAppUser _user = InAppUser();
    _user.latitude = latitude;
    _user.longitude = longitude;
    _user.street = street;

    var res = db.update(_userInfoTable, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      if (value == 1) {
        log.info("updateLocation success(id:${_user.id}):$_user");
      } else {
        log.info("updateLocation fail(id:${_user.id}):$value");
      }
    }).catchError((error) {
      logUtil.logger.e("updateLocation error(id:${_user.id}):$error");
    });
  }

  updateWifiInfo(String ssid, String bssid) async {
    log.info("updateWifiInfo");
    final db = await database;
    InAppUser _user = InAppUser();
    _user.ssid = ssid;
    _user.bssid = bssid;

    var res = db.update(_userInfoTable, _user.getUser(),
        where: "id = ?", whereArgs: [_user.id]);
    res.then((value) {
      if (value == 1) {
        log.info("updateWifiInfo success(id:${_user.id}):$_user");
      } else {
        log.info("updateWifiInfo fail(id:${_user.id}):$value");
      }
    }).catchError((error) {
      logUtil.logger.e("updateWifiInfo error(id:${_user.id}):$error");
    });
  }

  Future<bool> setTimeInfo(TimeData timeData) async {
    log.info("setTimeInfo(${timeData.getTime()})");
    final db = await database;

    // data will be replaced if DB already has same column.
    var res = await db.insert(_timeInfoTable, timeData.getTime(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (res == 1) {
      log.info("setTimeInfo success:${timeData.getTime()}");
      TimeData().updateTime(timeData);
      return true;
    }

    log.info("setTimeInfo failed");
    return false;
  }

  Future<TimeData> getTimeInfo(int date) async {
    log.info("getTimeInfo");
    var db = await database;

    TimeData _timeData = TimeData();

    var res =
        await db.query(_timeInfoTable, where: 'date = ?', whereArgs: [date]);
    if (res.isEmpty) {
      log.info("getTimeInfo fail(date:$date):has no timeInfo");
      return null;
    }

    _timeData.setTime(res.first);

    log.info("getTimeInfo success(date:$date):${_timeData.getTime()}");
    return _timeData;
  }
}
