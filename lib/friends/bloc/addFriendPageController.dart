import 'package:get/get.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';

class AddFriendPageController extends GetxController {
  late UserInfo user;
  var hasInput = false;

  Future<UserInfo> loadUserInfo() async {
    return UserRepository().getUserInfo();
  }

  void on() {
    hasInput = true;
    update();
  }

  void off() {
    hasInput = false;
    update();
  }

  bool getHasInput() {
    return hasInput;
  }
}
