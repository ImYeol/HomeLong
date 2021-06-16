import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/view/loginPage.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
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
    log.info("kakaoLogin");
    Future<bool> success = _authenticationRepository.kakaoLogin();
    success.then((value) {
      if (value == true) {
        log.info("authentication repository success");
        emit(LoginState.LOGIN);
      } else {
        log.info("authentication repository fail");
        emit(LoginState.LOGOUT);
      }
    }).catchError((error) {
      logUtil.logger.e("authentication repository fail:$error");
      emit(LoginState.LOGOUT);
    });
  }

  void facebookLogin() {
    log.info("facebookLogin");
    Future<bool> success = _authenticationRepository.facebookLogin();

    success.then((value) {
      if (value == true) {
        log.info("authentication repository success");
        emit(LoginState.LOGIN);
      } else {
        log.info("authentication repository fail");
        emit(LoginState.LOGOUT);
      }
    }).catchError((error) {
      logUtil.logger.e(error);
      emit(LoginState.LOGOUT);
    });
  }

  dbInfoLogin() async {
    log.info("dbInfoLogin");

    // get user info from inner DB.
    InAppUser _user = await DBHelper().getUserInfo();
    if (_user == null) {
      // DB has not user info.
      emit(LoginState.LOGOUT);
      return;
    }

    log.info("user info:${_user.getUser()}");
    if (_user.id != "") {
      // DB has user info.
      emit(LoginState.LOGIN);
    }
  }

  dbInfoLogOut() async {
    log.info("dbInfoLogOut");
    try {
      await DBHelper().deleteUserInfo();
    } on Exception catch (_) {
      logUtil.logger.e("error : failed to delete user");
    }
    emit(LoginState.LOGOUT);
  }
}
