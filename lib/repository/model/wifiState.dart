import 'package:homg_long/proxy/model/timeData.dart';

abstract class WifiState {
  final String ssid;
  final String bssid;
  final TimeData timeData;

  const WifiState({this.ssid, this.bssid, this.timeData});

  String get _ssid => ssid;
  String get _bssid => bssid;
  TimeData get _timeData => timeData;
}

class WifiConnected extends WifiState {
  WifiConnected(String ssid, String bssid, TimeData timeData)
      : super(ssid: ssid, bssid: bssid, timeData: timeData);
}

class WifiDisConnected extends WifiState {
  WifiDisConnected(String ssid, String bssid, TimeData timeData)
      : super(ssid: ssid, bssid: bssid, timeData: timeData);
}

class WifiInfoSaved extends WifiState {
  WifiInfoSaved(String ssid, String bssid) : super(ssid: ssid, bssid: bssid);
}

class WifiInfoSaveFailed extends WifiState {
  WifiInfoSaveFailed(String ssid, String bssid)
      : super(ssid: ssid, bssid: bssid);
}
