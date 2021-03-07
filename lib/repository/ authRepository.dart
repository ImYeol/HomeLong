import 'dart:async';
import 'dart:convert';
import 'package:homg_long/login/login.dart';

import 'model/userInfo.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';

class AuthenticationRepository {
  UserInfo get user {
    return _userInfo;
  }

  UserInfo _userInfo;

  Future<bool> kakaoLogin() async {
    KakaoContext.clientId = "234991db49db0e7808bf5cea94beabff";
    KakaoContext.javascriptClientId = "79ea01450f767ff5cca20131e7ff75bf";

    // check kakao app is installed in phone.
    final kakaoTalkInstalled = await isKakaoTalkInstalled();
    print("kakaoTalkInstalled: $kakaoTalkInstalled");

    if (kakaoTalkInstalled == true) {
      // login with kakao app.
      return await _loginWithKakao();
    } else {
      // login with kakao web view.
      return await _loginWithKakaoWebview();
    }
  }

  Future<bool> _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      return await _issueAccessToken(code);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print("token=$token");
      return await _putKakaoInfo(token.accessToken);
    } catch (e) {
      print("error on issuing access token: $e");
      return false;
    }
  }

  // register user info to server.
  Future<bool> _putKakaoInfo(String token) async {
    try {
      // var user = await UserApi.instance.me();
      //
      // _userInfo = UserInfo(id: "1", email: "2", name: null, photo: null);
      //
      // var url = 'http://localhost:8080/kakao/register';
      // var body = jsonEncode({
      //   'id': user.id,
      //   'token': token,
      // });
      // print("body:" + body.toString());
      // final response = await http.post(
      //   url,
      //   body: body,
      // );
      // print("http response:" + response.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _loginWithKakaoWebview() async {
    try {
      var code = await AuthCodeClient.instance.request();
      print("code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
