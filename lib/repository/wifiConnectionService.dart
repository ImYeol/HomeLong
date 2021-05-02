import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WifiConnectionService {
  final period = 5; // second
  final Connectivity _connectivity = Connectivity();
  final WifiInfo _wifiInfo = WifiInfo();

  StreamController<WifiState> _onNewData =
      StreamController<WifiState>.broadcast();
  Stream<WifiState> get onNewData => _onNewData.stream;

  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult> _connectivitySubscription = null;
  ConnectivityResult currentConnectivityState = ConnectivityResult.none;

  String ssid = "Unknonw";
  String bssid = "Unknonw";
  TimeData timeData = TimeData();
  Timer timer;

  WifiConnectionService();

  void init() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    loadUserInfo();
    initConnectivity();
    print("wifi service init");
  }

  TimeData getCurrentTimeData() {
    return timeData;
  }

  bool loadUserInfo() {
    // load user info
    DBHelper().getUser();
    timeData.setFromTimeString(InAppUser().timeInfo);
    return true;
  }

  bool saveTimeInfo() {
    DBHelper().updateTimeInfo(timeData.toTimeInfoString());
    return true;
  }

  void dispose() {
    _onNewData.close();
    _connectivitySubscription.cancel();
    _connectivitySubscription = null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }
    if (Platform.isAndroid) {
      print('Checking Android permissions');
      Permission permission = Permission.location;
      PermissionStatus permissionStatus = await permission.status;
      // Blocked?
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.undetermined ||
          permissionStatus == PermissionStatus.restricted) {
        // Ask the user to unblock
        print('ask request');
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          print('Location permission granted');
        } else {
          print('Location permission not granted');
        }
      } else {
        print('Permission already granted (previous execution?)');
      }
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    currentConnectivityState = result;

    switch (result) {
      case ConnectivityResult.wifi:
        ssid = await getWifiSsid();
        bssid = await getWifiBssid();

        _connectionStatus = '$result\n'
            'Wifi Name: $ssid\n'
            'Wifi BSSID: $bssid\n';
        print(_connectionStatus);
        _onNewData.sink.add(WifiConnected(ssid, bssid, timeData));
        starCounter();
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        _onNewData.sink.add(WifiDisConnected(ssid, bssid, timeData));
        stopCounter();
        saveTimeInfo();
        print(_connectionStatus);
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        _onNewData.sink.add(WifiDisConnected(ssid, bssid, timeData));
        stopCounter();
        print(_connectionStatus);
        break;
    }
  }

  Future<String> getWifiSsid() async {
    String wifiName = "Unknonw";
    try {
      if (!kIsWeb && Platform.isIOS) {
        LocationAuthorizationStatus status =
            await _wifiInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _wifiInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _wifiInfo.getWifiName();
        } else {
          wifiName = await _wifiInfo.getWifiName();
        }
      } else {
        wifiName = await _wifiInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiName = "Failed to get Wifi Name";
    }
    return wifiName;
  }

  Future<String> getWifiBssid() async {
    String wifiBSSID = "Unknonw";
    try {
      if (!kIsWeb && Platform.isIOS) {
        LocationAuthorizationStatus status =
            await _wifiInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _wifiInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _wifiInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _wifiInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _wifiInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = "Failed to get Wifi BSSID";
    }
    return wifiBSSID;
  }

  void starCounter() {
    print("startTimer : ${timeData.timeData == null}");
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      timeData.updateTime(period);
      print("onMinuteTimeEvent : " + period.toString());
      _onNewData.sink.add(WifiConnected(ssid, bssid, timeData));
    });
  }

  void stopCounter() {
    print("stopTimer");
    timer.cancel();
  }
}
