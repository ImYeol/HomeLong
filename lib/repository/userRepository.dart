import 'package:homg_long/repository/db/userDB.dart';
import 'package:homg_long/repository/proxy/userProxy.dart';

import 'model/userInfo.dart';

abstract class UserAPI {
  Future<bool> setUserInfo(UserInfo userInfo);
  Future<UserInfo> getUserInfo();
  Future<bool> deleteUserInfo();
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street);
  Future<bool> updateWifiInfo(String ssid, String bssid);
}

class UserRepository implements UserAPI {
  late UserDB _db;
  late UserProxy _proxy;

  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal() {
    this._db = UserDB();
    this._proxy = UserProxy();
  }

  void init() {
    _db.init();
  }

  Future<bool> openDatabase() async {
    return _db.openDatabase();
  }

  bool isLoginSessionValid() {
    return _db.isLoginSessionValid();
  }

  @override
  Future<UserInfo> getUserInfo() async {
    UserInfo userInfo = await _db.getUserInfo();
    if (userInfo.id != "") {
      return userInfo;
    }
    // when get user info from databases is failed
    // request from server
    return await _proxy.getUserInfo();
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    return await _db.setUserInfo(userInfo) &&
        await _proxy.setUserInfo(userInfo);
  }

  @override
  Future<bool> deleteUserInfo() async {
    return await _db.deleteUserInfo() && await _proxy.deleteUserInfo();
  }

  @override
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    return await _db.updateLocationInfo(latitude, longitude, street) &&
        await _proxy.updateLocationInfo(latitude, longitude, street);
  }

  @override
  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    return await _db.updateWifiInfo(ssid, bssid) &&
        await _proxy.updateWifiInfo(ssid, bssid);
  }
}
