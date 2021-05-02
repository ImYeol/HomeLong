import 'dart:async';
import 'dart:convert';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/repository/db.dart';

import 'model/InAppUser.dart';
import 'model/userInfo.dart';
import 'package:homg_long/const/URL.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:homg_long/const/statusCode.dart';

class AuthenticationRepository {
  UserInfo get user {
    return _userInfo;
  }

  UserInfo _userInfo;
  var loginStatusCode;

  Future<bool> fakeLogin() async {
    InAppUser _user = InAppUser();
    _user.setUser({
      'id': "aaa",
      'image': null,
    });

    DBHelper().deleteUser();
    DBHelper().setUser(_user);

    _userInfo = UserInfo(
        bssid: "unknown",
        ssid: "unknown",
        id: "aaa",
        timeInfo: TimeData(),
        image: null);

    return Future.delayed(Duration(milliseconds: 10), () => true);
  }

  Future<bool> kakaoLogin() async {
    // homelong kakao info
    KakaoContext.clientId = "234991db49db0e7808bf5cea94beabff";
    KakaoContext.javascriptClientId = "79ea01450f767ff5cca20131e7ff75bf";

    // check kakao app is installed in phone.
    final kakaoTalkInstalled = await isKakaoTalkInstalled();
    print("[kakao] kakaoTalkInstalled: $kakaoTalkInstalled");

    if (kakaoTalkInstalled == true) {
      // login with kakao app.
      return await _loginWithKakao();
    } else {
      // login with kakao web view.
      return await _loginWithKakaoWebview();
    }
  }

  // login with kakao app.
  Future<bool> _loginWithKakao() async {
    try {
      print("[kakao] loginWithKakao");
      // request authorization code.
      var code = await AuthCodeClient.instance.requestWithTalk();
      print("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      print(e);
      return false;
    }
  }

  // login with kakao web view.
  Future<bool> _loginWithKakaoWebview() async {
    try {
      print("[kakao] loginWithKakaoWebview");
      // request authorization code.
      var code = await AuthCodeClient.instance.request();
      print("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      print(e);
      return false;
    }
  }

  // authorization with auth code.
  Future<bool> _issueAccessToken(String authCode) async {
    try {
      print("[kakao] issueAccessToken");
      // request user token with authorization code.
      var token = await AuthApi.instance.issueAccessToken(authCode);
      print("[kakao] token=$token");
      AccessTokenStore.instance.toStore(token);

      // request user info with kakao account.
      return await _getKakaoInfo();
    } catch (e) {
      print("[kakao] error on issuing access token: $e");
      return false;
    }
  }

  // get user info.
  // register user info when user is not registered before.
  Future<bool> _getKakaoInfo() async {
    print("[kakao] getKakaoInfo");
    try {
      User user = await UserApi.instance.me();

      // login request body.
      var body = jsonEncode({
        'id': user.id.toString(),
        'image': user.properties["profile_image"],
      });
      print("[kakao] put kakao info body:" + body.toString());

      InAppUser _user = InAppUser();
      _user.setUser({
        'id': user.id.toString(),
        'image': user.properties["profile_image"],
      });

      DBHelper().deleteUser();
      DBHelper().setUser(_user);

      // post request.
      var url = URL.kakaoLoginURL;
      final response = await http.post(
        url,
        body: body,
      );
      print(
          "[kakao] http response statusCode:" + response.statusCode.toString());
      if (response.statusCode == statusCode.statusOK) {
        print("[kakao] success");
        return true;
      } else {
        print("[kakao] fail");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // login with facebook.
  Future<bool> facebookLogin() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        var body = jsonEncode({
          'id': accessToken.userId,
        });
        print("body:" + body.toString());

        var url = URL.facebookLoginURL;
        final response = await http.post(
          url,
          body: body,
        );
        print("http response statusCode:$response.statusCode");
        loginStatusCode = response.statusCode;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

    if (loginStatusCode == statusCode.statusOK)
      return true;
    else {
      return false;
    }
  }
}
