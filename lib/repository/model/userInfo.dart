import 'package:homg_long/proxy/model/timeData.dart';

class UserInfo {
  final String id;
  final String image;
  final String ssid;
  final String bssid;
  final TimeData timeInfo;

  String get _id => id;
  String get _image => image;
  String get _ssid => ssid;
  String get _bssid => bssid;
  TimeData get _timeInfo => timeInfo;

  const UserInfo({this.id, this.image, this.ssid, this.bssid, this.timeInfo});
}