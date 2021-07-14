import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:logging/logging.dart';

class AuthenticationDB implements Authentication {
  final logUtil = LogUtil();
  final log = Logger("DBHelper");

  @override
  Future<UserInfo> facebookLogin() {
    return null;
  }

  @override
  Future<UserInfo> kakaoLogin() {
    return null;
  }
}
