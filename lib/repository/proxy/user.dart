import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/user.dart';

class UserProxy implements User {
  @override
  Future<UserInfo> getUserInfo() async {
    // TODO: implement getUserInfo
    return null;
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    // TODO: implement setUserInfo
    return true;
  }

  @override
  Future<bool> updateLocationInfo(
      double latitude, double longitude, String street) async {
    // TODO: implement updateLocationInfo
    return true;
  }

  @override
  Future<bool> updateWifiInfo(String ssid, String bssid) async {
    // TODO: implement updateWifiInfo
    return true;
  }

  @override
  Future<bool> deleteUserInfo() async {
    // TODO: implement deleteUserInfo
    return true;
  }
}
