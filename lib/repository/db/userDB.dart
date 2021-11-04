import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db/DBHelper.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserDB implements UserAPI {
  final logUtil = LogUtil();
  final log = Logger("UserDB");

  @override
  Future<UserInfo> getUserInfo() async {
    log.info("getUserInfo");

    final db = await DBHelper().getDatabase;

    var res = await db?.query(DBHelper.userInfoTable);
    if (res == null || res.length == 0) {
      log.warning("getUserInfo fail(table($res) is empty)");
      await db?.execute('''
        create table ${DBHelper.userInfoTable}(id TEXT PRIMARY KEY, name TEXT, image TEXT, ssid TEXT, bssid TEXT, street TEXT, initDate INTEGER, latitude REAL, longitude REAL)
        ''');
      await db?.execute('''
          CREATE TABLE ${DBHelper.userInfoTable}(date TEXT PRIMARY KEY, timeList TEXT, totalMinute INTEGER)
          ''');
      //return UserInfo();
      res = await db?.query(DBHelper.userInfoTable);
    }
    if (res == null) {
      return UserInfo();
    }
    log.info("getUserInfo success(${res.first})");
    return UserInfo.fromJson(res.first);
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    log.info("setUserInfo($userInfo)");

    final prefs = await SharedPreferences.getInstance();

    final db = await DBHelper().getDatabase;

    var res = await db?.insert(DBHelper.userInfoTable, userInfo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (res == 1) {
      log.info("setUserInfo success(id:${userInfo.id})");
      prefs.setString('id', userInfo.id);
      return true;
    }

    log.warning("setUserInfo fail(id:${userInfo.id})");
    return false;
  }

  @override
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    log.info("updateLocationInfo");

    final db = await DBHelper().getDatabase;

    UserInfo userInfo = await getUserInfo();
    userInfo.latitude = latitude;
    userInfo.longitude = longitude;
    userInfo.street = street;

    var res = db?.update(DBHelper.userInfoTable, userInfo.toJson(),
        where: "id = ?", whereArgs: [userInfo.id]);
    res?.then((value) {
      if (value == 1) {
        log.info("updateLocationInfo success(id:${userInfo.id}):$userInfo");
        return true;
      } else {
        log.info("updateLocationInfo fail(id:${userInfo.id}):$value");
        return false;
      }
    }).catchError((error) {
      logUtil.logger.e("updateLocationInfo error(id:${userInfo.id}):$error");
      return false;
    });

    return false;
  }

  @override
  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    log.info("updateWifiInfo");

    final db = await DBHelper().getDatabase;

    UserInfo userInfo = await getUserInfo();
    userInfo.ssid = ssid;
    userInfo.bssid = bssid;

    var res = db?.update(DBHelper.userInfoTable, userInfo.toJson(),
        where: "id = ?", whereArgs: [userInfo.id]);
    res?.then((value) {
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

  @override
  Future<bool> deleteUserInfo() async {
    log.info("deleteUserInfo");

    final db = await DBHelper().getDatabase;

    UserInfo userInfo = await getUserInfo();
    if (userInfo == null) {
      log.info("table($DBHelper.userInfoTable) is already empty");
      return true;
    }

    var res = db?.delete(DBHelper.userInfoTable,
        where: "id = ?", whereArgs: [userInfo.id]);
    res?.then((value) {
      if (value == 1) {
        log.info("deleteUserInfo success(id:${userInfo.id})");
        return true;
      } else {
        log.info("deleteUserInfo fail(id:${userInfo.id}):$value");
        return false;
      }
    }).catchError((error) {
      logUtil.logger.e("deleteUserInfo error(id:${userInfo.id}):$error");
      return false;
    });

    return false;
  }
}
