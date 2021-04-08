abstract class WifiConnectionInfo {
  final String bssid;
  final String ssid;
  final int hour;
  final int minute;

  const WifiConnectionInfo({this.bssid, this.ssid, this.hour, this.minute});

  String get macAddr => bssid;
  String get wifiName => ssid;
  int get curHour => hour;
  int get curMinute => minute;
}

class WifiConnected extends WifiConnectionInfo {
  const WifiConnected(String bssid, String ssid, int hour, int minute)
      : //assert(bssid == null),
        super(bssid: bssid, ssid: ssid, hour: hour, minute: minute);
}

class WifiNotconnected extends WifiConnectionInfo {
  const WifiNotconnected(String bssid, String ssid, int hour, int minute)
      : //assert(bssid == null),
        super(bssid: bssid, ssid: ssid, hour: hour, minute: minute);
  String get macAddr => "00:00:00:00";
}
