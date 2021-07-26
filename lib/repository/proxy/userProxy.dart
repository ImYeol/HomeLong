import 'dart:convert';

import 'package:homg_long/const/StatusCode.dart';
import 'package:homg_long/const/URL.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProxy implements UserAPI {
  LogUtil logUtil = LogUtil();
  final log = Logger("UserProxy");

  @override
  Future<UserInfo> getUserInfo() async {
    log.info("getUserInfo");

    final prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      URL.getUserInfoURL,
      headers: {'id': prefs.getString('id')},
    );

    if (response.statusCode == StatusCode.statusOK) {
      log.info("get user info success(${response.body}");
      return UserInfo.fromJson(json.decode(response.body));
    } else {
      log.info("get user info fail(${response.statusCode}, ${response.body})");
      return null;
    }
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    log.info("setUserInfo");

    var response = await http.post(
      URL.setUserInfoURL,
      body: json.encode(userInfo),
    );

    if (response.statusCode == StatusCode.statusOK) {
      log.info("set user info success");
      return true;
    } else {
      log.info("set user info fail(${response.statusCode}, ${response.body})");
      return false;
    }
  }

  @override
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    // TODO: implement updateLocationInfo
    return true;
  }

  @override
  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    // TODO: implement updateWifiInfo
    return true;
  }

  @override
  Future<bool> deleteUserInfo() async {
    // TODO: implement deleteUserInfo
    return true;
  }
}
