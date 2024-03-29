class WifiState {
  final String ssid;
  final String bssid;

  const WifiState({required this.ssid, required this.bssid});

  String get _ssid => ssid;

  String get _bssid => bssid;
}

class WifiConnected extends WifiState {
  WifiConnected(String ssid, String bssid) : super(ssid: ssid, bssid: bssid);
}

class WifiDisConnected extends WifiState {
  WifiDisConnected(String ssid, String bssid) : super(ssid: ssid, bssid: bssid);
}

class WifiInfoSaved extends WifiState {
  WifiInfoSaved(String ssid, String bssid) : super(ssid: ssid, bssid: bssid);
}

class WifiInfoSaveFailed extends WifiState {
  WifiInfoSaveFailed(String ssid, String bssid)
      : super(ssid: ssid, bssid: bssid);
}
