import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:homg_long/friends/friendsPage.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';

class FriendsPageController extends ChangeNotifier {
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

  Future<FriendInfo> searchFriend(String fid) async {
    final user = await userRepository.getUserInfo();
    return friendRepository.getFriendInfo(user.id, fid);
  }

  void addFriend(FriendInfo friend) async {
    final user = await userRepository.getUserInfo();
    bool added = await friendRepository.setFriendInfo(user.id, friend);
    if (added) {
      _friends.value.add(friend);
      if (friend.atHome) {
        _homeFriends.value.add(friend);
      }
    }
  }

  void deleteFriend(FriendInfo friend) async {
    final user = await userRepository.getUserInfo();
    bool deleted = await friendRepository.deleteFriendInfo(user.id, friend.id);
    if (deleted) {
      _friends.value.remove(friend);
      if (friend.atHome) {
        _homeFriends.value.remove(friend);
      }
    }
  }
}
