import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';

enum LoginState { NONE, LOGIN, UNLOGIN, SETUP }

class LoginController extends GetxController {
  LogUtil logUtil = LogUtil();
  final log = Logger('LoginController');
  bool needSetup = false;

  LoginController();

  bool isLoginSessionValid() {
    return UserRepository().isLoginSessionValid();
  }

  // void kakaoLogin() async {
  //   log.info("kakaoLogin");
  //   Future<UserInfo> _userInfo = AuthenticationRepository().kakaoLogin();
  //   _userInfo.then((value) {
  //     if (value.isValid() != true) {
  //       log.info("authentication repository kakao login fail");
  //       emit(LoginState.UNLOGIN);
  //     } else {
  //       setUserInfo(value);
  //       emit(LoginState.LOGIN);
  //     }
  //   }).catchError((onError) {
  //     log.info("authentication repository kakao login return error:$onError");
  //     emit(LoginState.UNLOGIN);
  //   });
  // }

  void facebookLogin() {
    log.info("facebookLogin");
    Future<UserInfo> _userInfo = AuthenticationRepository().facebookLogin();
    _userInfo.then((value) {
      if (value.isValid()) {
        setUserInfo(value);
        needSetup = checkIfHomeInfoNotSet(value);
        log.info("needSetup : $needSetup");
        needSetup ? Get.offAndToNamed("/GPS") : Get.offAndToNamed("/Main");
      } else {
        log.info("authentication repository facebook login fail");
      }
    }).catchError((onError) {
      log.info(
          "authentication repository facebook login return error:$onError");
    });
  }

  setUserInfo(UserInfo userInfo) {
    log.info("serUserInfo");
    Future<bool> success = UserRepository().setUserInfo(userInfo);
    success.then((value) {
      if (value == false) {
        logUtil.logger.e("user repository set user info fail");
      }
    }).catchError((onError) {
      logUtil.logger.e("user repository set user return error:$onError");
    });
  }

  void googleLogin() {
    log.info("google login");
    Future<UserInfo> _userInfo = AuthenticationRepository().googleLogin();
    _userInfo.then((value) {
      if (value.isValid()) {
        setUserInfo(value);
        needSetup = checkIfHomeInfoNotSet(value);
        log.info("needSetup : $needSetup");
        needSetup ? Get.offAndToNamed("/GPS") : Get.offAndToNamed("/Main");
      } else {
        log.info("authentication repository google login fail");
        needSetup = false;
      }
    }).catchError((onError) {
      log.info("authentication repository google login return error:$onError");
    });
  }

  void logOut() async {
    await UserRepository().deleteUserInfo();
    needSetup = false;
    log.info("logout called");
    Get.offAndToNamed("/Login");
  }

  bool checkIfHomeInfoNotSet(UserInfo user) {
    final invalidUser = InvalidUserInfo();
    return (user.ssid == invalidUser.ssid || user.bssid == invalidUser.bssid) &&
        (user.latitude == invalidUser.latitude ||
            user.longitude == invalidUser.longitude);
  }
}
