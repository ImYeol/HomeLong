import 'package:homg_long/repository/db/friendDB.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/proxy/friendProxy.dart' as proxy;
import 'package:logging/logging.dart';

class FriendRepository {
  final log = Logger("UserProxy");
  late FriendDB _db;
  //late FriendProxy _proxy;

  static final FriendRepository _instance = FriendRepository._internal();

  factory FriendRepository() {
    return _instance;
  }

  FriendRepository._internal() {
    this._db = FriendDB();
    //this._proxy = FriendProxy();
  }

  void init() {
    _db.init();
  }

  Future<bool> openDatabase() async {
    return _db.openDatabase();
  }

  Future<List<FriendInfo>> getAllFriends(String uid) async {
    //return proxy.getAllFriendInfo(uid);
    log.info("getAllFriends called");
    var friendList = await _db.getAllFriendInfo();
    if (friendList.isEmpty) {
      log.info("getAllFriends : friendList is empty");
      friendList = await proxy.getAllFriendInfo(uid);
      // update all friends to local DB
      friendList.forEach((friend) {
        _db.setFriendInfo(friend);
      });
    }
    return friendList;
  }

  Future<FriendInfo> getFriendInfo(String uid, String fid) async {
    //return proxy.getFriendInfo(uid, fid);
    FriendInfo friendInfo = await _db.getFriendInfo(fid);
    if (friendInfo.id != InvalidUserInfo.INVALID_ID) {
      log.info("getFriendInfo : friendInfo.id invalid");
      return await proxy.getFriendInfo(uid, fid);
    }
    // when get user info from databases is failed
    // request from server
    return FriendInfo.invalidFriend();
  }

  Future<bool> setFriendInfo(String uid, FriendInfo friend) async {
    //return proxy.setFriendInfo(uid, friend.id);
    return await _db.setFriendInfo(friend) &&
        await proxy.setFriendInfo(uid, friend.id);
  }

  Future<bool> deleteFriendInfo(String uid, String fid) async {
    //return proxy.deleteFriendInfo(uid, fid);
    return await _db.deleteFriendInfo(fid) &&
        await proxy.deleteFriendInfo(uid, fid);
  }
}
