class UserInfo {
  final String id;
  final String image;
  final String ssid;
  final String bssid;

  String get _id => id;
  String get _image => image;
  String get _ssid => ssid;
  String get _bssid => bssid;

  const UserInfo({this.id, this.image, this.ssid, this.bssid});
}
