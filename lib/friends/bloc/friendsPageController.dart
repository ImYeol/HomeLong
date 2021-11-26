import 'package:flutter/material.dart';
import 'package:homg_long/repository/model/userInfo.dart';

class FriendsPageController extends ChangeNotifier {
  List<UserInfo> _homeFriends = <UserInfo>[];
  List<UserInfo> _friends = <UserInfo>[];

  List<UserInfo> get homeFriends => _homeFriends;
  List<UserInfo> get frineds => _friends;

  Future<void> loadFreinds() async {
    _friends = await Future.delayed(
        Duration(milliseconds: 300),
        () => [
              UserInfo(id: "id11111", name: "11111", image: "empty"),
              UserInfo(id: "id22222", name: "22222", image: "empty"),
              UserInfo(id: "id33333", name: "33333", image: "empty"),
              UserInfo(id: "id44444", name: "44444", image: "empty"),
              UserInfo(id: "id55555", name: "55555", image: "empty"),
              UserInfo(id: "id66666", name: "66666", image: "empty")
            ]);

    _homeFriends = await Future.delayed(
        Duration(milliseconds: 300),
        () => [
              UserInfo(id: "id11111", name: "11111", image: "empty"),
              UserInfo(id: "id44444", name: "44444", image: "empty"),
              UserInfo(id: "id55555", name: "55555", image: "empty"),
              UserInfo(id: "id66666", name: "66666", image: "empty")
            ]);
  }

  void searchFriend(String id) async {}

  void addFriend(String id) async {}

  void deleteFriend(String id) async {}
}
