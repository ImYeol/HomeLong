import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WifiConnectionService {
  WifiConnectionService._internal();

  /// Instance of [WifiConnectionService].
  static final instance = WifiConnectionService._internal();
  final logUtil = LogUtil();
  final Connectivity _connectivity = Connectivity();
  final WifiInfo _wifiInfo = WifiInfo();

  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult> _connectivitySubscription = null;
  ConnectivityResult currentConnectivityState = ConnectivityResult.none;

  String ssid = "Unknonw";
  String bssid = "Unknonw";

  void Function(WifiState) callback;

  void listenWifiStateChanged(Function(WifiState) callback) {
    logUtil.logger.d("registerWifiStateCallback");
    this.callback = callback;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void unlistenWifiStateChanged() {
    logUtil.logger.d("unRegisterWifiStateCallback");
    this.callback = null;
    _connectivitySubscription.cancel();
    _connectivitySubscription = null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkNowConnectionState() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      logUtil.logger.e(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }
    if (Platform.isAndroid) {
      logUtil.logger.d('Checking Android permissions');
      Permission permission = Permission.location;
      PermissionStatus permissionStatus = await permission.status;
      // Blocked?
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.limited ||
          permissionStatus == PermissionStatus.restricted) {
        // Ask the user to unblock
        logUtil.logger.d('ask request');
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          logUtil.logger.d('Location permission granted');
        } else {
          logUtil.logger.d('Location permission not granted');
        }
      } else {
        logUtil.logger.d('Permission already granted (previous execution?)');
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
        logUtil.logger.d(_connectionStatus);
        // if not null, call the function
        callback?.call(WifiConnected(ssid, bssid));
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        callback?.call(WifiDisConnected(ssid, bssid));
        logUtil.logger.d(_connectionStatus);
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        callback?.call(WifiDisConnected(ssid, bssid));
        logUtil.logger.d(_connectionStatus);
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
      logUtil.logger.e(e);
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
      logUtil.logger.e(e);
      wifiBSSID = "Failed to get Wifi BSSID";
    }
    return wifiBSSID;
  }
}
