import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:homg_long/friends/friendsPage.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';

class FriendsPageController extends ChangeNotifier {
  final log = Logger("FriendsPageController");
  var _homeFriends = <FriendInfo>[].obs;
  var _friends = <FriendInfo>[].obs;

  List<FriendInfo> get homeFriends => _homeFriends.value;
  List<FriendInfo> get frineds => _friends.value;

  final UserRepository userRepository;
  final FriendRepository friendRepository;

  FriendsPageController(
      {required this.userRepository, required this.friendRepository});

  void loadFreinds() async {
    final user = await userRepository.getUserInfo();
    _friends.value = await friendRepository.getAllFriends(user.id);
    _homeFriends.value =
        _friends.value.where((friend) => friend.atHome).toList();
  }

  void goToSearchPage() async {
    final user = await userRepository.getUserInfo();
    var searchedFriend =
        await Get.toNamed('/AddFriend', arguments: user) as FriendInfo;
    log.info("goToSearchPage result $searchedFriend");
    if (searchedFriend != null) {
      loadFreinds();
    }
  }

  void deleteFriend(FriendInfo friend) async {
    final user = await userRepository.getUserInfo();
    bool deleted = await friendRepository.deleteFriendInfo(user.id, friend.id);
    if (deleted) {
      loadFreinds();
    }
  }
}
