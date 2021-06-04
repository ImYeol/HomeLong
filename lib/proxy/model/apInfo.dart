class APInfo {
  final String ssid;
  final String bssid;

  const APInfo({this.ssid, this.bssid});

  String get _ssid => ssid;

  String get _bssid => bssid;

  factory APInfo.fromJson(Map<String, dynamic> json) {
    return APInfo(ssid: json['ssid'], bssid: json['bssid']);
  }
}
