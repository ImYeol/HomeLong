import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:homg_long/repository/%20authRepository.dart';

enum LoginState { LOGIN, UNLOGIN }

class KakaoLoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  KakaoLoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(null);

  void login() {
    Future<bool> success = _authenticationRepository.kakaoLogin();

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
}
