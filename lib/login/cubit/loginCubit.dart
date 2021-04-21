import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/login/login.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/login/view/loginPage.dart';
import 'package:homg_long/repository/model/InAppUser.dart';


class loginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  loginCubit(this._authenticationRepository) : super(null){
    assert(_authenticationRepository != null);
    this.dbInfoLogin();
  }

  void kakaoLogin() {
    print("[loginCubit] kakaoLogin");
    Future<bool> success = _authenticationRepository.kakaoLogin();
    print("[loginCubit] kakaoLogin:"+success.toString());

    success.then((value) {
      if (value == true) {
        emit(LoginState.LOGIN);
      } else {
        emit(LoginState.UNLOGIN);
      }
    }).catchError((error) {
      print(error);
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
      print(error);
      emit(LoginState.UNLOGIN);
    });
  }

  dbInfoLogin() async{
    print("[loginCubit] dbInfoLogin");
    await DBHelper().getUser();
    InAppUser _user = InAppUser();
    print("[loginCubit] user:"+_user.getUser().toString());
    if (_user.id != null){
      emit(LoginState.LOGIN);
    }
  }

  dbInfoLogOut() async{
    print("[loginCubit] dbInfoLogOut");
    await DBHelper().deleteUser();
    InAppUser _user = InAppUser();
    print("[loginCubit] user:"+_user.getUser().toString());
    emit(LoginState.UNLOGIN);
  }
}
