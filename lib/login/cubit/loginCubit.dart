import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/view/loginPage.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:logging/logging.dart';

class LoginCubit extends Cubit<LoginState> {
  LogUtil logUtil = LogUtil();
  final log = Logger('LoginCubit');

  LoginCubit() : super(null);

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
      if (value.isValid() != true) {
        log.info("authentication repository facebook login fail");
        emit(LoginState.UNLOGIN);
      } else {
        setUserInfo(value);
        emit(LoginState.LOGIN);
      }
    }).catchError((onError) {
      log.info(
          "authentication repository facebook login return error:$onError");
      emit(LoginState.UNLOGIN);
    });
  }

  setUserInfo(UserInfo userInfo) {
    log.info("serUserInfo");
    Future<bool> success = UserRepository().setUserInfo(userInfo);
    success.then((value) {
      if (value != true) {
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
      if (value.isValid() != true) {
        log.info("authentication repository google login fail");
        emit(LoginState.UNLOGIN);
      } else {
        setUserInfo(value);
        emit(LoginState.LOGIN);
      }
    }).catchError((onError) {
      log.info("authentication repository google login return error:$onError");
      emit(LoginState.UNLOGIN);
    });
  }
}
