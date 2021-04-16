class UserInfo {
  final String id;
  final String image;
  final String ssid;
  final String bssid;
  final int timeInfo;

  String get _id => id;
  String get _image => image;
  String get _ssid => ssid;
  String get _bssid => bssid;
  int get _timeInfo => timeInfo;

  const UserInfo({this.id, this.image, this.ssid, this.bssid, this.timeInfo});
}
