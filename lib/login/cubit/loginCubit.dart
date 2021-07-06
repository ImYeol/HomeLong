import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/db/DBHelper.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/view/loginPage.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:logging/logging.dart';

class LoginCubit extends Cubit<LoginState> {
  LogUtil logUtil = LogUtil();
  final log = Logger('LoginCubit');

  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(null) {
    assert(_authenticationRepository != null);
    this.dbInfoLogin();
  }

  void kakaoLogin() {
    Future<bool> success = _authenticationRepository.kakaoLogin();
    success.then((value) {
      if (value == true) {
        log.info("authentication repository success");
        emit(LoginState.LOGIN);
      } else {
        log.info("authentication repository fail");
        emit(LoginState.UNLOGIN);
      }
    }).catchError((error) {
      log.info("authentication repository fail:$error");
      emit(LoginState.UNLOGIN);
    });
  }

  void facebookLogin() {
    Future<bool> success = _authenticationRepository.facebookLogin();

    success.then((value) {
      if (value == true) {
        emit(LoginState.LOGIN);
      } else {
        emit(LoginState.UNLOGIN);
      }
    }).catchError((error) {
      logUtil.logger.e(error);
      emit(LoginState.UNLOGIN);
    });
  }

  dbInfoLogin() async {
    log.info("dbInfoLogin");
    UserInfo _user = await DBHelper().getUserInfo();
    if (_user == null) {
      emit(LoginState.UNLOGIN);
      return;
    }
    log.info("user info:${_user.toJson()}");
    if (_user.id != "") {
      emit(LoginState.LOGIN);
    }
  }

  dbInfoLogOut() async {
    try {
      await DBHelper().deleteUserInfo();
    } on Exception catch (_) {
      logUtil.logger.e("error : failed to delete user");
    }
    emit(LoginState.UNLOGIN);
  }
}
