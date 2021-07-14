import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:homg_long/db/DBHelper.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/home/counterPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/rank/bloc/rankCubit.dart';
import 'package:homg_long/rank/rankPage.dart';
import 'package:homg_long/repository/connectivityServiceWrapper.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/screen/model/appScreenState.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logging/logging.dart';

class AppScreenCubit extends Cubit<AppScreenState> with UserActionManager {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  final LogUtil logUtil = LogUtil();
  final log = Logger("AppScreenCubit");

  int _currentPage = 0;
  final period = 5; // second
  UserInfo _userInfo;

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

  final _pages = [CounterPage(), RankPage(), RankPage()];
  final _connectivityServiceWrapper = ConnectivityServiceWrapper.instance;
  bool isAtHome = false;
  TimeData timeData;
  Timer timer;

  AppScreenCubit() : super(PageLoading(CircularProgressIndicator()));

  int get currentPage => _currentPage;

  GeofenceService get geofenceService => _geofenceServiceWrapper;

  void init() {
    loadUserInfo();
    loadTimeData();
  }

  void loadUserInfo() async {
    _userInfo = await DBHelper().getUserInfo();
    if (_userInfo != null) {
      startGeofenceServiceWrapper();
      startConnectivityServiceWrapper();
    }
  }

  void loadTimeData() async {
    int today = getDay(DateTime.now());
    timeData = await DBHelper().getTimeData(today);
    if (timeData == null) {
      timeData = TimeData();
    }
  }

  void startConnectivityServiceWrapper() {
    if (_userInfo.ssid == null || _userInfo.ssid.isEmpty) return;

    log.info("init Wifi service");
    _connectivityServiceWrapper.listenWifiStateChanged(_onWifiStateChanged);
    _connectivityServiceWrapper.checkNowConnectionState();
  }

  void startGeofenceServiceWrapper() {
    if (_userInfo.latitude == null || _userInfo.longitude == null) {
      return;
    }

    log.info("init geofence service");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _geofenceServiceWrapper
          .addGeofenceStatusChangedListener(_onGeofenceStatusChanged);
      _geofenceServiceWrapper.addActivityChangedListener(_onActivityChanged);
      _geofenceServiceWrapper.addStreamErrorListener(_onError);
      _geofenceServiceWrapper.start(_geofenceList).catchError(_onError);
    });
  }

  bool needForegroundTask() {
    DBHelper().getUserInfo();
    _userInfo = UserInfo();

    if (_userInfo.ssid != null && _userInfo.ssid.isNotEmpty) return true;
    if (_userInfo.latitude.isFinite || _userInfo.longitude.isFinite)
      return true;

    return false;
  }

  void dispose() {
    //_geofenceStreamController.close();
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Position position) async {
    log.info('geofence: ${geofence.toMap()}');
    log.info('geofenceRadius: ${geofenceRadius.toMap()}');
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
    log.info('prevActivity: ${prevActivity.toMap()}');
    log.info('currActivity: ${currActivity.toMap()}\n');
  }

  void _onWifiStateChanged(WifiState state) {
    bool atHome = state is WifiConnected;
    onUserLocationChanged(atHome);
  }

  void _onError(dynamic error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      log.info('Undefined error: $error');
      return;
    }

    log.info('ErrorCode: $errorCode');
  }

  @override
  bool isUserAtHome() {
    return isAtHome;
  }

  @override
  void onUserLocationChanged(bool atHome) {
    // check if Already enabled
    log.info("onUserLocationChanged - ${atHome} + tihs.isAtHome: ${isAtHome}");
    if (this.isAtHome == atHome) return;
    isAtHome = atHome;
    if (isAtHome) {
      enterHome();
    } else {
      exitHome();
    }
  }

  @override
  void enterHome() {
    if (timeData == null) {
      loadTimeData();
    }
    DateTime now = DateTime.now();
    log.info("enterTime: ${getTime(now)}");

    if (timeData.updateEnterTime(getTime(now))) {
      DBHelper().setTimeData(timeData);
    }
  }

  @override
  void exitHome() {
    if (timeData == null) {
      loadTimeData();
    }
    DateTime now = DateTime.now();
    log.info("exitHome: ${getDay(now)} - ${getTime(now)}");
    if (timeData.updateExitTime(getTime(now))) {
      DBHelper().setTimeData(timeData);
    }
    updatePastTimeData(30, now);
  }

  void updatePastTimeData(int maxNumberOfUpdateDay, DateTime targetDate) async {
    for (int i = 0; i < maxNumberOfUpdateDay; i++) {
      DateTime aDayAgo = targetDate.subtract(const Duration(days: 1));
      TimeData pastTimeData = await DBHelper().getTimeData(getDay(aDayAgo));

      // TODO: 초기가입 날짜 추가 및 아래 라인 삭제
      if (pastTimeData == null) return;

      if (pastTimeData.timeList.length == 0) {
        pastTimeData.updateEnterTime(getTime(getOnTime(aDayAgo)));
        pastTimeData.updateExitTime(getTime(getOnTime(targetDate)));
        DBHelper().setTimeData(pastTimeData);
      } else {
        pastTimeData.updateExitTime(getTime(getOnTime(targetDate)));
        DBHelper().setTimeData(pastTimeData);
        break;
      }
    }
  }

  @override
  void changeDay() async {
    DateTime now = DateTime.now();
    DateTime onTimeToday = getOnTime(now);
    DateTime aDayAgo = now.subtract(const Duration(days: 1));

    TimeData timeData = await DBHelper().getTimeData(getTime(aDayAgo));

    timeData.updateExitTime(getTime(onTimeToday));
  }

  @override
  Future<int> getTotalTime(DateTime date) async {
    final localTimeData = await DBHelper().getTimeData(getDay(date));
    return localTimeData == null
        ? 0
        : localTimeData.getTotalTime(date, isAtHome);
  }
}
