import 'package:hive/hive.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:logging/logging.dart';

class FriendDB {
  static const String FRIEND_DB_NAME = "FriendDB";
  final String DB = 'FriendDB';
  final log = Logger("FriendDB");

  void init() {
    Hive.registerAdapter(FriendInfoAdapter());
  }

  Future<bool> openDatabase() async {
    final userDbBox = Hive.isBoxOpen(FRIEND_DB_NAME)
        ? Hive.box(FRIEND_DB_NAME)
        : await Hive.openBox(FRIEND_DB_NAME);
    return userDbBox.isOpen;
  }

  Future<List<FriendInfo>> getAllFriendInfo() async {
    final box = Hive.isBoxOpen(FRIEND_DB_NAME)
        ? Hive.box(FRIEND_DB_NAME)
        : await Hive.openBox(FRIEND_DB_NAME);
    var friendList = box.values.toList();
    return friendList.cast<FriendInfo>();
  }

  Future<FriendInfo> getFriendInfo(String fid) async {
    log.info("getFriendInfo");
    FriendInfo friendInfo = Hive.box(FRIEND_DB_NAME)
        .get(fid, defaultValue: FriendInfo.invalidFriend());
    return friendInfo;
  }

  Future<bool> setFriendInfo(FriendInfo friendInfo) async {
    log.info("setFriendInfo(${friendInfo.id})");
    if (friendInfo.id == InvalidUserInfo.INVALID_ID) {
      log.warning("setUserInfo - invalid userInfo");
      return false;
    }
    await Hive.box(FRIEND_DB_NAME).put(friendInfo.id, friendInfo);
    return true;
  }

  Future<bool> deleteFriendInfo(String fid) async {
    log.info("deleteFriendInfo");

    if (fid == InvalidUserInfo.INVALID_ID) {
      log.warning("deleteUserInfo - invalid userInfo");
      return false;
    }

    await Hive.box(FRIEND_DB_NAME).delete(fid);
    return true;
  }
}
