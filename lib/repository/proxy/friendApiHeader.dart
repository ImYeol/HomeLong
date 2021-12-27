import 'package:homg_long/repository/model/userInfo.dart';

class FriendApiHeader {
  static Map<String, String> builder(String myId, String friendId) {
    if (myId == InvalidUserInfo.INVALID_ID ||
        friendId == InvalidUserInfo.INVALID_ID) {
      return {};
    }

    return {'id': myId, 'fid': friendId};
  }
}
