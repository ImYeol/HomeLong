import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/login/login.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/login/view/loginPage.dart';

class LoginCubit extends Cubit<LoginState> {
  LogUtil logUtil = LogUtil();
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(null){
    assert(_authenticationRepository != null);
    this.dbInfoLogin();
  }

  void kakaoLogin() {
    logUtil.logger.d("kakaoLogin");
    Future<bool> success = _authenticationRepository.kakaoLogin();
    success.then((value){
      logUtil.logger.d("authentication repository success");
      emit(LoginState.LOGIN);
    }).catchError((error) {
      logUtil.logger.d("authentication repository fail:$error");
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

  void fakeLogin() {
    Future<bool> success = _authenticationRepository.fakeLogin();

    success.then((value) {
      logUtil.logger.d("fake login : ${value}");
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
    logUtil.logger.d("[loginCubit] dbInfoLogin");
    await DBHelper().getUser();
    InAppUser _user = InAppUser();
    logUtil.logger.d("[loginCubit] user:" + _user.getUser().toString());
    if (_user.id != null) {
      emit(LoginState.LOGIN);
    }
  }

  dbInfoLogOut() async {
    logUtil.logger.d("[loginCubit] dbInfoLogOut");
    await DBHelper().deleteUser();
    InAppUser _user = InAppUser();
    logUtil.logger.d("[loginCubit] user:" + _user.getUser().toString());
    emit(LoginState.UNLOGIN);
  }
}
