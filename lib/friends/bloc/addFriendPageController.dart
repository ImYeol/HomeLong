import 'package:get/get.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';

class AddFriendPageController extends GetxController {
  var _searchedFriend = FriendInfo().obs;
  var _inputText = "".obs;
  final UserInfo user;
  final FriendRepository friendRepository;

  AddFriendPageController({required this.user, required this.friendRepository});

  FriendInfo get searchedFriend => _searchedFriend.value;
  String get inputText => _inputText.value;

  set inputText(String text) {
    _inputText.value = text;
  }

  void searchFriend() async {
    final input = _inputText.value;
    _searchedFriend.value =
        await friendRepository.getFriendInfo(user.id, input);
  }

  void addFriend(FriendInfo friend) async {
    final added = await friendRepository.setFriendInfo(user.id, friend);
    if (added) {
      print("addFriend added");
      Get.back(result: friend);
    } else {
      print("addFriend not added");
      Get.back();
    }
  }
}
