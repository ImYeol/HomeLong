import 'dart:async';
import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:homg_long/const/URL.dart';
import 'package:homg_long/const/statusCode.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logging/logging.dart';

import 'model/InAppUser.dart';

class AuthenticationRepository {
  LogUtil logUtil = LogUtil();
  final log = Logger("AuthenticationRepository");

  var loginStatusCode;

  Future<bool> kakaoLogin() async {
    // homelong kakao info
    KakaoContext.clientId = "234991db49db0e7808bf5cea94beabff";
    KakaoContext.javascriptClientId = "79ea01450f767ff5cca20131e7ff75bf";

    // check kakao app is installed in phone.
    final kakaoTalkInstalled = await isKakaoTalkInstalled();
    log.info("[kakao] kakaoTalkInstalled: $kakaoTalkInstalled");

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
      log.info("[kakao] loginWithKakao");
      // request authorization code.
      var code = await AuthCodeClient.instance.requestWithTalk();
      log.info("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      logUtil.logger.e(e);
      return false;
    }
  }

  // login with kakao web view.
  Future<bool> _loginWithKakaoWebview() async {
    try {
      log.info("[kakao] loginWithKakaoWebview");
      // request authorization code.
      var code = await AuthCodeClient.instance.request();
      log.info("[kakao] code=$code");
      return await _issueAccessToken(code);
    } catch (e) {
      logUtil.logger.e(e);
      return false;
    }
  }

  // authorization with auth code.
  Future<bool> _issueAccessToken(String authCode) async {
    try {
      log.info("[kakao] issueAccessToken");
      // request user token with authorization code.
      var token = await AuthApi.instance.issueAccessToken(authCode);
      log.info("[kakao] token=$token");
      AccessTokenStore.instance.toStore(token);

      // request user info with kakao account.
      return await _getKakaoInfo();
    } catch (e) {
      log.info("[kakao] error on issuing access token: $e");
      return false;
    }
  }

  // get user info.
  // register user info when user is not registered before.
  Future<bool> _getKakaoInfo() async {
    log.info("[kakao] getKakaoInfo");
    try {
      User user = await UserApi.instance.me();
      log.info("kakao user info:$user");

      // delete pre account info.
      await DBHelper().deleteUserInfo();

      InAppUser _user = InAppUser();
      _user.setUser({
        'id': user.id.toString(),
        'image': user.properties["profile_image"],
        'name': user.properties["nickname"],
      });

      // set up new account.
      await DBHelper().setUserInfo(_user);

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
        log.info("[kakao] success");
        return true;
      } else {
        log.info("[kakao] fail(${response.statusCode})");
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
        log.info('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        await DBHelper().deleteUserInfo();

        InAppUser _user = InAppUser();
        _user.setUser({
          "id": accessToken.userId,
        });
        await DBHelper().setUserInfo(_user);

        var body = jsonEncode({
          'id': accessToken.userId,
        });
        log.info("body:" + body.toString());

        Uri url = Uri.parse(URL.facebookLoginURL);
        final response = await http.post(
          url,
          body: body,
        );
        log.info("http response:$response");
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
      log.info("[facebook] login");
      return true;
    } else {
      log.info("[facebook] fail($loginStatusCode)");
      return false;
    }
  }
}
