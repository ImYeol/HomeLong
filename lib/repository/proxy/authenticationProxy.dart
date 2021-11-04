import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:homg_long/const/AppKey.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logging/logging.dart';

class AuthenticationProxy implements Authentication {
  LogUtil logUtil = LogUtil();
  final log = Logger("AuthenticationProxy");

  @override
  Future<UserInfo> facebookLogin() async {
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

        return UserInfo(
          id: accessToken.userId,
          initDate: getDay(DateTime.now()),
        );
      case FacebookLoginStatus.cancelledByUser:
        log.warning('Login cancelled by the user.');
        return UserInfo();
      case FacebookLoginStatus.error:
        log.warning('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        return UserInfo();
      default:
        log.warning('Login error:${result.errorMessage}');
        return UserInfo();
    }
  }

  @override
  Future<UserInfo> kakaoLogin() async {
    _setAppKey();

    final kakaoTalkInstalled = await isKakaoTalkInstalled();
    if (kakaoTalkInstalled == true) {
      return await _loginWithKakao();
    } else {
      return await _loginWithKakaoWebview();
    }
  }

  void _setAppKey() {
    KakaoContext.clientId = AppKey.KakaoNativeAppKey;
    KakaoContext.javascriptClientId = AppKey.KakaoJavaScriptKey;
  }

  Future<UserInfo> _loginWithKakao() async {
    try {
      log.info("_loginWithKakao");

      var authCode = await AuthCodeClient.instance.requestWithTalk();
      log.info("code=$authCode");

      return await _issueAccessToken(authCode);
    } catch (e) {
      logUtil.logger.e(e);
      return UserInfo();
    }
  }

  Future<UserInfo> _loginWithKakaoWebview() async {
    try {
      log.info("_loginWithKakaoWebview");

      var authCode = await AuthCodeClient.instance.request();
      log.info("code=$authCode");

      return await _issueAccessToken(authCode);
    } catch (e) {
      logUtil.logger.e(e);
      return UserInfo();
    }
  }

  Future<UserInfo> _issueAccessToken(String authCode) async {
    try {
      log.info("_issueAccessToken");

      var token = await AuthApi.instance.issueAccessToken(authCode);
      log.info("token=$token");

      AccessTokenStore.instance.toStore(token);

      return await _getKakaoInfo();
    } catch (e) {
      log.info("error on issuing access token: $e");
      return UserInfo();
    }
  }

  Future<UserInfo> _getKakaoInfo() async {
    try {
      log.info("_getKakaoInfo");

      User user = await UserApi.instance.me();
      log.info("user info:$user");

      return UserInfo(
        id: user.id.toString(),
        name: user.properties?["nickname"] ?? '',
        image: user.properties?["profile_image"] ?? '',
        initDate: getDay(DateTime.now()),
      );
    } catch (e) {
      logUtil.logger.e(e);
      return UserInfo();
    }
  }
}
