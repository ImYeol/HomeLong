import 'package:hive/hive.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/friend.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';

class UserDB implements UserAPI {
  static const String USER_DB_NAME = "UserDB";
  static const String USER_INFO = "UserInfo";

  static const String FRIEND_DB_NAME = "FriendDB";
  static const String FRIEND = "Friend";

  final logUtil = LogUtil();
  final log = Logger("UserDB");

  void init() {
    Hive.registerAdapter(UserInfoAdapter());
    Hive.registerAdapter(FriendAdapter());
  }

  Future<bool> openDatabase() async {
    final userDbBox = Hive.isBoxOpen(USER_DB_NAME)
        ? Hive.box(USER_DB_NAME)
        : await Hive.openBox(USER_DB_NAME);
    log.info("userDbBox.isOpen:", userDbBox.isOpen);

    final friendDbBox = Hive.isBoxOpen(FRIEND_DB_NAME)
        ? Hive.box(FRIEND_DB_NAME)
        : await Hive.openBox(FRIEND_DB_NAME);
    log.info("friendDbBox.isOpen:", friendDbBox.isOpen);

    return userDbBox.isOpen && friendDbBox.isOpen;
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

  Future<bool> addFriend(String id, String fid) async {
    log.info("addFriend");
    UserInfo userInfo = Hive.box(USER_DB_NAME).get(USER_INFO);

    if (userInfo.id != id) {
      log.warning("user id is not matched");
      log.warning("db user id:", userInfo.id);
      log.warning("request user id:", id);
      return false;
    }

    if (userInfo.friend.contains(fid) == true) {
      log.info("already friend with ", fid);
    } else {
      userInfo.friend.add(fid);
      log.info("add friend ", fid);
    }

    return true;
  }
}
