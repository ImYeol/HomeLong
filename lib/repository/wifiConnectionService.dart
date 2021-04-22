import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WifiConnectionService {
  StreamController<WifiState> _onNewData =
      StreamController<WifiState>.broadcast();
  Stream<WifiState> get onNewData => _onNewData.stream;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final WifiInfo _wifiInfo = WifiInfo();
  final period = 5; // second
  String ssid;
  String bssid;
  int duration = 0;
  Timer timer;

  WifiConnectionService();

  void init() {
    ssid = "Unknonw";
    bssid = "Unknonw";
    initConnectivity();
    if (_connectivitySubscription == null || _connectivitySubscription.isPaused)
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    print("wifi service init");
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
    switch (result) {
      case ConnectivityResult.wifi:
        ssid = await getWifiSsid();
        bssid = await getWifiBssid();

        _connectionStatus = '$result\n'
            'Wifi Name: $ssid\n'
            'Wifi BSSID: $bssid\n';
        print(_connectionStatus);
        _onNewData.sink.add(WifiConnected(ssid, bssid, duration));
        //starCounter();
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        duration = 0;
        _connectionStatus = result.toString();
        _onNewData.sink.add(WifiDisConnected(ssid, bssid));
        stopCounter();
        print(_connectionStatus);
        break;
      default:
        duration = 0;
        _connectionStatus = 'Failed to get connectivity.';
        _onNewData.sink.add(WifiDisConnected(ssid, bssid));
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
    print("startTimer");
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      duration += period;
      print("onMinuteTimeEvent : " + duration.toString());
      _onNewData.sink.add(WifiConnected(ssid, bssid, duration));
    });
  }

  void stopCounter() {
    timer.cancel();
  }
}
