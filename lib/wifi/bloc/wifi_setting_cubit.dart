import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/wifi/model/wifi_connection_info.dart';

class WifiSettingCubit extends Cubit<WifiConnectionInfo> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  final WifiInfo _wifiInfo = WifiInfo();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  int minute;
  int hour;
  int totalMinute;
  int totalHour;
  String bssid;
  String ssid;

  WifiSettingCubit(WifiConnectionInfo state) : super(state);

  void subsribeWifiInfo() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void unSubscribeWifiInfo() {
    _connectivitySubscription.cancel();
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
        String wifiName, wifiBSSID, wifiIP;

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

        try {
          wifiIP = await _wifiInfo.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        _connectionStatus = '$result\n'
            'Wifi Name: $wifiName\n'
            'Wifi BSSID: $wifiBSSID\n'
            'Wifi IP: $wifiIP\n';
        bssid = wifiBSSID;
        ssid = wifiName;
        print(_connectionStatus);
        emit(WifiConnected(bssid, ssid, 0, 0));
        startTimer();
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        emit(WifiNotconnected(null, null, hour, minute));
        print(_connectionStatus);
        stopTimer();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        emit(WifiNotconnected(null, null, hour, minute));
        print(_connectionStatus);
        stopTimer();
        break;
    }
  }

  void startTimer() {
    _stopWatchTimer.minuteTime.listen((value) {
      minute = value;
      emit(WifiConnected(bssid, ssid, hour, minute));
      print('minuteTime $value');
    });
    _stopWatchTimer.secondTime.listen((value) {
      hour = value;
      emit(WifiConnected(bssid, ssid, hour, minute));
      print('secondTime $value');
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    // start
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void stopTimer() async {
    if (_stopWatchTimer.isRunning)
      // Stop
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    //await _stopWatchTimer.dispose();
  }
}
