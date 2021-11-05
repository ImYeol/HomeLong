import 'dart:async';

import 'package:homg_long/repository/db/authenticationDB.dart';
import 'package:homg_long/repository/model/userInfo.dart';

import 'proxy/authenticationProxy.dart';

abstract class Authentication {
  Future<UserInfo> facebookLogin();
  Future<UserInfo> kakaoLogin();
}

class AuthenticationRepository implements Authentication {
  late AuthenticationProxy _proxy;
  late AuthenticationDB _db;

  static final AuthenticationRepository _instance =
      AuthenticationRepository._internal();

  factory AuthenticationRepository() {
    return _instance;
  }

  AuthenticationRepository._internal() {
    this._db = AuthenticationDB();
    this._proxy = AuthenticationProxy();
  }

  @override
  Future<UserInfo> facebookLogin() async {
    return _proxy.facebookLogin();
  }

  @override
  Future<UserInfo> kakaoLogin() async {
    return _proxy.kakaoLogin();
  }
}
