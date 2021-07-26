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

  LoginCubit() : super(null) {
    this.autoLogin();
  }

  void kakaoLogin() async {
    log.info("kakaoLogin");
    Future<UserInfo> _userInfo = AuthenticationRepository().kakaoLogin();
    _userInfo.then((value) {
      if (value != null) {
        setUserInfo(value);
        emit(LoginState.LOGIN);
      } else {
        log.info("authentication repository kakao login fail");
        emit(LoginState.UNLOGIN);
      }
    }).catchError((onError) {
      log.info("authentication repository kakao login return error:$onError");
      emit(LoginState.UNLOGIN);
    });
  }

  void facebookLogin() {
    log.info("facebookLogin");
    Future<UserInfo> _userInfo = AuthenticationRepository().facebookLogin();
    _userInfo.then((value) {
      if (value != null) {
        setUserInfo(value);
        emit(LoginState.LOGIN);
      } else {
        log.info("authentication repository facebook login fail");
        emit(LoginState.UNLOGIN);
      }
    }).catchError((onError) {
      log.info(
          "authentication repository facebook login return error:$onError");
      emit(LoginState.UNLOGIN);
    });
  }

  autoLogin() async {
    log.info("autoLogin");
    Future<UserInfo> _userInfo = UserRepository().getUserInfo();
    _userInfo.then((value) {
      if (value != null) {
        log.info("auto login success(${value.toJson()}");
        emit(LoginState.LOGIN);
      } else {
        log.info("auto login fail");
        emit(LoginState.UNLOGIN);
      }
    }).catchError((onError) {
      log.info("auto login return error:$onError");
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
}
