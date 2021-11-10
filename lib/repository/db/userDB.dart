import 'package:hive/hive.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';

class UserDB implements UserAPI {
  static const String USER_DB_NAME = "UserDB";
  static const String USER_INFO = "UserInfo";

  final logUtil = LogUtil();
  final log = Logger("UserDB");

  void init() {
    Hive.registerAdapter(UserInfoAdapter());
  }

  Future<bool> openDatabase() async {
    final userDbBox = Hive.isBoxOpen(USER_DB_NAME)
        ? Hive.box(USER_DB_NAME)
        : await Hive.openBox(USER_DB_NAME);
    return userDbBox.isOpen;
  }

  bool isLoginSessionValid() {
    final userInfo =
        Hive.box(USER_DB_NAME).get(USER_INFO, defaultValue: InvalidUserInfo());
    log.info("isLoginSessionValid - id = ${userInfo.id}");
    return !(userInfo is InvalidUserInfo);
  }

  @override
  Future<UserInfo> getUserInfo() async {
    log.info("getUserInfo");
    UserInfo userInfo =
        Hive.box(USER_DB_NAME).get(USER_INFO, defaultValue: InvalidUserInfo());
    return userInfo;
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    log.info("setUserInfo($userInfo)");
    if (userInfo.id == InvalidUserInfo.INVALID_ID) {
      log.warning("setUserInfo - invalid userInfo");
      return false;
    }
    Hive.box(USER_DB_NAME).put(USER_INFO, userInfo);
    return true;
  }

  @override
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    log.info("updateLocationInfo");

    UserInfo userInfo = await getUserInfo();
    if (userInfo.id == InvalidUserInfo.INVALID_ID) {
      log.warning("updateLocationInfo - invalid userInfo");
      return false;
    }
    userInfo.latitude = latitude;
    userInfo.longitude = longitude;
    userInfo.street = street;

    Hive.box(USER_DB_NAME).put(USER_INFO, userInfo);
    return true;
  }

  @override
  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    log.info("updateWifiInfo");

    UserInfo userInfo = await getUserInfo();
    if (userInfo.id == InvalidUserInfo.INVALID_ID) {
      log.warning("updateWifiInfo - invalid userInfo");
      return false;
    }
    userInfo.ssid = ssid;
    userInfo.bssid = bssid;

    Hive.box(USER_DB_NAME).put(USER_INFO, userInfo);
    return true;
  }

  @override
  Future<bool> deleteUserInfo() async {
    log.info("deleteUserInfo");

    UserInfo userInfo = await getUserInfo();
    if (userInfo.id == InvalidUserInfo.INVALID_ID) {
      log.warning("deleteUserInfo - invalid userInfo");
      return false;
    }

    Hive.box(USER_DB_NAME).delete(USER_INFO);
    return true;
  }
}
