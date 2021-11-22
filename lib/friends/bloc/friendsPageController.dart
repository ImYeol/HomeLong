import 'package:flutter/material.dart';
import 'package:homg_long/friends/model/friendInfo.dart';

class FriendsPageController extends ChangeNotifier {
  List<FriendInfo> _homeFriends = <FriendInfo>[];
  List<FriendInfo> _friends = <FriendInfo>[];

  List<FriendInfo> get homeFriends => _homeFriends;
  List<FriendInfo> get frineds => _friends;

  Future<void> loadFreinds() async {
    _friends = await Future.delayed(
        Duration(milliseconds: 300),
        () => [
              FriendInfo(id: "id11111", name: "11111", image: "empty"),
              FriendInfo(id: "id22222", name: "22222", image: "empty"),
              FriendInfo(id: "id33333", name: "33333", image: "empty"),
              FriendInfo(id: "id44444", name: "44444", image: "empty"),
              FriendInfo(id: "id55555", name: "55555", image: "empty"),
              FriendInfo(id: "id66666", name: "66666", image: "empty")
            ]);

    _homeFriends = await Future.delayed(
        Duration(milliseconds: 300),
        () => [
              FriendInfo(id: "id11111", name: "11111", image: "empty"),
              FriendInfo(id: "id44444", name: "44444", image: "empty"),
              FriendInfo(id: "id55555", name: "55555", image: "empty"),
              FriendInfo(id: "id66666", name: "66666", image: "empty")
            ]);
  }

  void searchFriend(String id) async {}

  void addFriend(String id) async {}

  void deleteFriend(String id) async {}
}
