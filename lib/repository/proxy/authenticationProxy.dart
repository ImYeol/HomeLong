import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homg_long/const/AppKey.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/model/userInfo.dart' as model;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logging/logging.dart';

class AuthenticationProxy implements Authentication {
  LogUtil logUtil = LogUtil();
  final log = Logger("AuthenticationProxy");

  @override
  Future<model.UserInfo> facebookLogin() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final auth.AuthCredential credential =
          auth.FacebookAuthProvider.credential(result.accessToken!.token);

      // Once signed in, return the UserCredential
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user == null) {
        log.warning("userCredential.user is null");
        return model.InvalidUserInfo();
      }

      if (userCredential.user!.email == "") {
        log.warning("userCredential.user.email is empty");
        return model.InvalidUserInfo();
      }

      return model.UserInfo(
          id: userCredential.user!.email ?? 'invalid',
          name: userCredential.user!.displayName ?? '',
          image: userCredential.user!.photoURL ?? '',
          initDate: DateTime.now().toString());
    } catch (e) {
      logUtil.logger.e(e);
      return model.InvalidUserInfo();
    }
  }

  @override
  Future<model.UserInfo> kakaoLogin() async {
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

  Future<model.UserInfo> _loginWithKakao() async {
    try {
      log.info("_loginWithKakao");

      var authCode = await AuthCodeClient.instance.requestWithTalk();
      log.info("code=$authCode");

      return await _issueAccessToken(authCode);
    } catch (e) {
      logUtil.logger.e(e);
      return model.InvalidUserInfo();
    }
  }

  Future<model.UserInfo> _loginWithKakaoWebview() async {
    try {
      log.info("_loginWithKakaoWebview");

      var authCode = await AuthCodeClient.instance.request();
      log.info("code=$authCode");

      return await _issueAccessToken(authCode);
    } catch (e) {
      logUtil.logger.e(e);
      return model.InvalidUserInfo();
    }
  }

  Future<model.UserInfo> _issueAccessToken(String authCode) async {
    try {
      log.info("_issueAccessToken");

      var token = await AuthApi.instance.issueAccessToken(authCode);
      log.info("token=$token");

      AccessTokenStore.instance.toStore(token);

      return await _getKakaoInfo();
    } catch (e) {
      log.info("error on issuing access token: $e");
      return model.InvalidUserInfo();
    }
  }

  Future<model.UserInfo> _getKakaoInfo() async {
    try {
      log.info("_getKakaoInfo");

      User user = await UserApi.instance.me();
      log.info("user info:$user");

      return model.UserInfo(
        id: user.id.toString(),
        name: user.properties?["nickname"] ?? '',
        image: user.properties?["profile_image"] ?? '',
        initDate: DateTime.now().toString(),
      );
    } catch (e) {
      logUtil.logger.e(e);
      return model.InvalidUserInfo();
    }
  }

  Future<model.UserInfo> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user == null) {
        log.warning("userCredential.user is null");
        return model.InvalidUserInfo();
      }

      if (userCredential.user!.email == "") {
        log.warning("userCredential.user.email is empty");
        return model.InvalidUserInfo();
      }

      return model.UserInfo(
        id: userCredential.user!.email ?? 'invalid',
        name: userCredential.user!.displayName ?? '',
        image: userCredential.user!.photoURL ?? '',
        initDate: DateTime.now().toString(),
      );
    } catch (e) {
      logUtil.logger.e(e);
      return model.InvalidUserInfo();
    }
  }
}
