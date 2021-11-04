import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class ConnectivityServiceWrapper {
  ConnectivityServiceWrapper._internal();

  /// Instance of [WifiConnectionService].
  static final instance = ConnectivityServiceWrapper._internal();
  final logUtil = LogUtil();
  final log = Logger("WifiConnectionService");

  final Connectivity _connectivity = Connectivity();
  final WifiInfo _wifiInfo = WifiInfo();

  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult>? _connectivitySubscription = null;
  ConnectivityResult currentConnectivityState = ConnectivityResult.none;

  String ssid = "Unknonw";
  String bssid = "Unknonw";

  void Function(WifiState)? callback;

  void listenWifiStateChanged(Function(WifiState) callback) {
    log.info("registerWifiStateCallback");
    this.callback = callback;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(onConnectionStatusChanged);
  }

  void unlistenWifiStateChanged() {
    log.info("unRegisterWifiStateCallback");
    this.callback = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkNowConnectionState() async {
    ConnectivityResult? result;
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
      log.info('Checking Android permissions');
      Permission permission = Permission.location;
      PermissionStatus permissionStatus = await permission.status;
      // Blocked?
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.limited ||
          permissionStatus == PermissionStatus.restricted) {
        // Ask the user to unblock
        log.info('ask request');
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          log.info('Location permission granted');
        } else {
          log.info('Location permission not granted');
        }
      } else {
        log.info('Permission already granted (previous execution?)');
      }
    }
    return onConnectionStatusChanged(result);
  }

  Future<void> onConnectionStatusChanged(ConnectivityResult? result) async {
    currentConnectivityState = result ?? ConnectivityResult.none;

    switch (result) {
      case ConnectivityResult.wifi:
        ssid = await getWifiSsid();
        bssid = await getWifiBssid();

        _connectionStatus = '$result\n'
            'Wifi Name: $ssid\n'
            'Wifi BSSID: $bssid\n';
        log.info(_connectionStatus);
        // if not null, call the function
        callback?.call(WifiConnected(ssid, bssid));
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        callback?.call(WifiDisConnected(ssid, bssid));
        log.info(_connectionStatus);
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        callback?.call(WifiDisConnected(ssid, bssid));
        log.info(_connectionStatus);
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
          wifiName = await _wifiInfo.getWifiName() ?? "Unknonw";
        } else {
          wifiName = await _wifiInfo.getWifiName() ?? "Unknonw";
        }
      } else {
        wifiName = await _wifiInfo.getWifiName() ?? "Unknonw";
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
          wifiBSSID = await _wifiInfo.getWifiBSSID() ?? "Unknonw";
        } else {
          wifiBSSID = await _wifiInfo.getWifiBSSID() ?? "Unknonw";
        }
      } else {
        wifiBSSID = await _wifiInfo.getWifiBSSID() ?? "Unknonw";
      }
    } on PlatformException catch (e) {
      logUtil.logger.e(e);
      wifiBSSID = "Failed to get Wifi BSSID";
    }
    return wifiBSSID;
  }
}
