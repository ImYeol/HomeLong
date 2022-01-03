import 'package:homg_long/repository/db/friendDB.dart';
import 'package:homg_long/repository/db/knockDB.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/knockFeed.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/proxy/friendProxy.dart' as proxy;
import 'package:logging/logging.dart';

class FriendRepository {
  final log = Logger("FriendRepository");
  late FriendDB _db;
  late KnockDB _knockDb;
  //late FriendProxy _proxy;

  static final FriendRepository _instance = FriendRepository._internal();

  factory FriendRepository() {
    return _instance;
  }

  FriendRepository._internal() {
    this._db = FriendDB();
    this._knockDb = KnockDB();
    //this._proxy = FriendProxy();
  }

  void init() {
    _db.init();
    _knockDb.init();
  }

  Future<bool> openDatabase() async {
    return await _db.openDatabase() && await _knockDb.openDatabase();
  }

  Future<List<FriendInfo>> getAllFriends(String uid) async {
    //return proxy.getAllFriendInfo(uid);
    log.info("getAllFriends called");
    var friendList = await _db.getAllFriendInfo();
    //if (friendList.isEmpty) {
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
    log.info("getFriendInfo called");
    FriendInfo friendInfo = await _db.getFriendInfo(fid);
    if (friendInfo.id == InvalidUserInfo.INVALID_ID) {
      log.info("getFriendInfo : friendInfo.id invalid");
      return await proxy.getFriendInfo(uid, fid);
    }
    // when get user info from databases is failed
    // request from server
    return friendInfo;
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

  Future<bool> sendKnockMessage(String uid, String fid) async {
    bool sent = await proxy.sendKnockMessage(uid, fid);
    print("sendKnockMessage : $sent");
    if (sent) {
      KnockFeed feed = KnockFeed(
          senderId: uid, receiverId: fid, sentTime: DateTime.now().toString());
      saveKnockFeed(feed);
    }
    return sent;
  }

  Future<int> saveKnockFeed(KnockFeed feed) {
    print("saveKnockFeed : $feed");
    return _knockDb.saveKnockFeed(feed);
  }

  Future<List<KnockFeed>> loadAllKnockFeed() async {
    return _knockDb.loadAllKnockFeed();
  }
}
