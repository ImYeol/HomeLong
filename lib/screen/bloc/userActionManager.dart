import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/connectivityServiceWrapper.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/bloc/userActionEventObserver.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:logging/logging.dart';

class UserActionManager {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  final LogUtil logUtil = LogUtil();
  final log = Logger("UserActionManager");

  final _geofenceServiceWrapper = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // Create a [Geofence] list.
  final _geofenceList = <Geofence>[
    Geofence(
        id: 'place_1',
        latitude: 35.103422,
        longitude: 129.036023,
        radius: [
          GeofenceRadius(id: 'radius_100m', length: 100),
          GeofenceRadius(id: 'radius_25m', length: 25),
          GeofenceRadius(id: 'radius_250m', length: 250),
          GeofenceRadius(id: 'radius_200m', length: 200)
        ]),
  ];

  final _connectivityServiceWrapper = ConnectivityServiceWrapper.instance;
  bool isAtHome = false;
  WifiState wifiState = WifiState(ssid: '', bssid: '');
  UserActionEventObserver? _actionEventObserver;
  void Function(WifiState)? _wifiConnectionCallback;

  GeofenceService get geofenceService => _geofenceServiceWrapper;

  static final UserActionManager _instance = UserActionManager._internal();

  factory UserActionManager() {
    return _instance;
  }

  UserActionManager._internal();

  void init() {
    listenWifiStateChanged();
    initGeofenceService();
  }

  void listenWifiStateChanged() {
    log.info("init Wifi service");
    _connectivityServiceWrapper.listenWifiStateChanged(_onWifiStateChanged);
  }

  void checkNowConnectionState() async {
    _connectivityServiceWrapper.checkNowConnectionState();
  }

  void initGeofenceService() {
    log.info("init geofence service");
    _geofenceServiceWrapper
        .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceServiceWrapper.addActivityChangeListener(_onActivityChanged);
    _geofenceServiceWrapper.addStreamErrorListener(_onError);
  }

  void registerGeofence(double latitude, double longitude) {
    final geofenceList = <Geofence>[
      Geofence(
          id: 'place_1',
          latitude: latitude,
          longitude: longitude,
          radius: [
            GeofenceRadius(id: 'radius_100m', length: 100),
            GeofenceRadius(id: 'radius_25m', length: 25),
            GeofenceRadius(id: 'radius_250m', length: 250),
            GeofenceRadius(id: 'radius_200m', length: 200)
          ]),
    ];
    _geofenceServiceWrapper.start(geofenceList).catchError(_onError);
  }

  Future<bool> needForegroundTask() async {
    Future<UserInfo> _userInfo = UserRepository().getUserInfo();
    _userInfo.then((value) {
      if (value != null) {
        if (value.ssid != null && value.ssid.isNotEmpty) {
          return true;
        }

        if (value.bssid != null && value.bssid.isNotEmpty) {
          return true;
        }

        if (value.latitude.isFinite || value.longitude.isFinite) {
          return true;
        }

        return false;
      } else {
        logUtil.logger.e("user repository get user info fail");
        return false;
      }
    }).catchError((onError) {
      logUtil.logger.e("user repository get user info return error:$onError");
      return false;
    });

    return false;
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      dynamic position) async {
    log.info('geofence: ${geofence.toString()}');
    log.info('geofenceRadius: ${geofenceRadius.toString()}');
    log.info('geofenceStatus: ${geofenceStatus.toString()}\n');

    switch (geofenceStatus) {
      case GeofenceStatus.ENTER:
        onUserLocationChanged(true);
        break;
      case GeofenceStatus.EXIT:
        onUserLocationChanged(false);
        break;
      case GeofenceStatus.DWELL:
        break;
    }
  }

  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    log.info('prevActivity: ${prevActivity.toString()}');
    log.info('currActivity: ${currActivity.toString()}\n');
  }

  void _onWifiStateChanged(WifiState state) async {
    wifiState = state;
    // check user session
    UserInfo user = await UserRepository().getUserInfo();
    if (user is InvalidUserInfo) {
      log.info("onUserLocationChanged - InvalidUserInfo");
      return;
    }
    // check wifi address
    if (state.ssid == user.ssid && state.bssid == user.bssid) {
      onUserLocationChanged(state is WifiConnected);
    }
    _wifiConnectionCallback?.call(state);
  }

  void _onError(dynamic error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      log.info('Undefined error: $error');
      return;
    }

    log.info('ErrorCode: $errorCode');
  }

  bool isUserAtHome() {
    return isAtHome;
  }

  void onUserLocationChanged(bool atHome) {
    // check if Already enabled
    log.info("onUserLocationChanged - ${atHome} + this.isAtHome: ${isAtHome}");
    if (this.isAtHome == atHome) return;
    isAtHome = atHome;
    if (isAtHome) {
      enterHome();
    } else {
      exitHome();
    }
  }

  void enterHome() {
    DateTime now = DateTime.now();
    TimeRepository().saveEnterTime(now);
    _actionEventObserver?.onUserActionChanged(UserActionType.ENTER_HOME, now);
  }

  void exitHome() {
    DateTime now = DateTime.now();
    TimeRepository().saveExitTime(DateTime.now());
    _actionEventObserver?.onUserActionChanged(UserActionType.EXIT_HOME, now);
  }

  void registerUserActionEventObserver(UserActionEventObserver observer) {
    _actionEventObserver = observer;
  }

  void registerWifiStateChangeEventObserver(Function(WifiState) callback) {
    _wifiConnectionCallback = callback;
  }

  void unRegisterWifiStateChangeEventObserver() {
    _wifiConnectionCallback = null;
  }
}
