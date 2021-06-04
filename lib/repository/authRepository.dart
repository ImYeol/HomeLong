import 'dart:async';
import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:homg_long/const/URL.dart';
import 'package:homg_long/const/statusCode.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';

import 'model/InAppUser.dart';

class AuthenticationRepository {
  LogUtil logUtil = LogUtil();

  var loginStatusCode;

  // TODO: will be removed.
  Future<bool> fakeLogin() async {
    InAppUser _user = InAppUser();
    _user.setUser({
      'id': "aaa",
      'image': null,
    });
    await DBHelper().setUser(_user);

    return Future.delayed(Duration(milliseconds: 10), () => true);
  }

  Future<bool> kakaoLogin() async {
    // homelong kakao info
    KakaoContext.clientId = "234991db49db0e7808bf5cea94beabff";
    KakaoContext.javascriptClientId = "79ea01450f767ff5cca20131e7ff75bf";

    // check kakao app is installed in phone.
    final kakaoTalkInstalled = await isKakaoTalkInstalled();
    logUtil.logger.d("[kakao] kakaoTalkInstalled: $kakaoTalkInstalled");

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
      logUtil.logger.d("[kakao] loginWithKakao");
      // request authorization code.
      var code = await AuthCodeClient.instance.requestWithTalk();
      logUtil.logger.d("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      logUtil.logger.e(e);
      return false;
    }
  }

  // login with kakao web view.
  Future<bool> _loginWithKakaoWebview() async {
    try {
      logUtil.logger.d("[kakao] loginWithKakaoWebview");
      // request authorization code.
      var code = await AuthCodeClient.instance.request();
      logUtil.logger.d("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      logUtil.logger.e(e);
      return false;
    }
  }

  // authorization with auth code.
  Future<bool> _issueAccessToken(String authCode) async {
    try {
      logUtil.logger.d("[kakao] issueAccessToken");
      // request user token with authorization code.
      var token = await AuthApi.instance.issueAccessToken(authCode);
      logUtil.logger.d("[kakao] token=$token");
      AccessTokenStore.instance.toStore(token);

      // request user info with kakao account.
      return await _getKakaoInfo();
    } catch (e) {
      logUtil.logger.d("[kakao] error on issuing access token: $e");
      return false;
    }
  }

  // get user info.
  // register user info when user is not registered before.
  Future<bool> _getKakaoInfo() async {
    logUtil.logger.d("[kakao] getKakaoInfo");
    try {
      User user = await UserApi.instance.me();
      logUtil.logger.d("kakao user info:$user");

      // delete pre account info.
      await DBHelper().deleteUser();

      InAppUser _user = InAppUser();
      _user.setUser({
        'id': user.id.toString(),
        'image': user.properties["profile_image"],
        'name': user.properties["nickname"],
      });

      // set up new account.
      await DBHelper().setUser(_user);

      // post request.
      Uri url = Uri.parse(URL.kakaoLoginURL);

      // login request body.
      var body = jsonEncode({
        'id': user.id.toString(),
        'image': user.properties["profile_image"],
      });

      final response = await http.post(
        url,
        body: body,
      );

      if (response.statusCode == StatusCode.statusOK) {
        logUtil.logger.d("[kakao] success");
        return true;
      } else {
        logUtil.logger.d("[kakao] fail(${response.statusCode})");
        return false;
      }
    } catch (e) {
      logUtil.logger.e(e);
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
        logUtil.logger.d('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        await DBHelper().deleteUser();

        InAppUser _user = InAppUser();
        _user.setUser({
          "id": accessToken.userId,
        });
        await DBHelper().setUser(_user);

        var body = jsonEncode({
          'id': accessToken.userId,
        });
        logUtil.logger.d("body:" + body.toString());

        Uri url = Uri.parse(URL.facebookLoginURL);
        final response = await http.post(
          url,
          body: body,
        );
        logUtil.logger.d("http response:$response");
        loginStatusCode = response.statusCode;
        break;
      case FacebookLoginStatus.cancelledByUser:
        logUtil.logger.e('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        logUtil.logger.e('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

    if (loginStatusCode == StatusCode.statusOK) {
      logUtil.logger.d("[facebook] login");
      return true;
    } else {
      logUtil.logger.d("[facebook] fail($loginStatusCode)");
      return false;
    }
  }
}
