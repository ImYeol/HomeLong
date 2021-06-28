import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/home/counterPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/rank/bloc/rankCubit.dart';
import 'package:homg_long/rank/rankPage.dart';
import 'package:homg_long/repository/connectivityServiceWrapper.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/screen/model/appScreenState.dart';
import 'package:logging/logging.dart';

class AppScreenCubit extends Cubit<AppScreenState> with UserActionManager {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  final LogUtil logUtil = LogUtil();
  final log = Logger("AppScreenCubit");

  int _currentPage = 0;
  final period = 5; // second
  InAppUser _userInfo;
  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();
  var _atHomeCounterStreamController = StreamController<TimeData>();

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
  TimeData timeData = TimeData();
  Timer timer;

  AppScreenCubit() : super(PageLoading(CircularProgressIndicator()));

  int get currentPage => _currentPage;

  GeofenceService get geofenceService => _geofenceServiceWrapper;

  void init() {
    loadUserInfo();
    startGeofenceServiceWrapper();
    startConnectivityServiceWrapper();
    dispatchPage(currentPage);
  }

  void startConnectivityServiceWrapper() {
    if (_userInfo.ssid == null || _userInfo.ssid.isEmpty) return;

    log.info("init Wifi service");
    _connectivityServiceWrapper.listenWifiStateChanged(_onWifiStateChanged);
    _connectivityServiceWrapper.checkNowConnectionState();
  }

  void startGeofenceServiceWrapper() {
    if (_userInfo.latitude == double.infinity ||
        _userInfo.longitude == double.infinity) return;

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
    DBHelper().getUser();
    _userInfo = InAppUser();

    if (_userInfo.ssid != null && _userInfo.ssid.isNotEmpty) return true;
    if (_userInfo.latitude.isFinite || _userInfo.longitude.isFinite)
      return true;

    return false;
  }

  void dispose() {
    _activityStreamController.close();
    _geofenceStreamController.close();
    _atHomeCounterStreamController.close();
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
    //_geofenceStreamController.sink.add(geofence);
  }

  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    log.info('prevActivity: ${prevActivity.toMap()}');
    log.info('currActivity: ${currActivity.toMap()}\n');
    //_activityStreamController.sink.add(currActivity);
    saveTimeInfo();
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

  bool loadUserInfo() {
    // load user info
    DBHelper().getUser();
    _userInfo = InAppUser();
    log.info("user : $_userInfo");
    timeData.setFromTimeString(InAppUser().timeInfo);
    log.info("loadUserInfo : " + _userInfo?.toString());
    return true;
  }

  bool saveTimeInfo() {
    DBHelper().updateTimeInfo(timeData.toTimeInfoString());
    return true;
  }

  void dispatchPage(int tappedIndex) {
    _currentPage = tappedIndex;
    Widget widget = Container();
    log.info("counter controller closed : ${tappedIndex}");
    switch (tappedIndex) {
      case HOME_PAGE:
        log.info("counter controller closed");
        widget = BlocProvider(
          create: (_) => CounterCubit(this),
          child: _pages[0],
        );
        emit(CounterPageLoaded(widget));
        break;
      case RANK_PAGE:
        widget = BlocProvider(
          create: (_) => RankCubit(),
          child: _pages[1],
        );
        emit(RankPageLoaded(widget));
        break;
      case SETTING_PAGE:
        widget = BlocProvider(
          create: (_) => RankCubit(),
          child: _pages[1],
        );
        emit(SettingPageLoaded(widget));
    }
  }

  @override
  bool isUserAtHome() {
    return isAtHome;
  }

  @override
  void onUserLocationChanged(bool atHome) {
    // check if Already enabled
    if (this.isAtHome == isAtHome) return;
    this.isAtHome = isAtHome;
    if (isAtHome) {
      enterHome();
    } else {
      exitHome();
    }
  }

  @override
  void enterHome() {}

  @override
  void exitHome() {}

  @override
  void changeDay() {}

  @override
  int getTotalTime(DateTime date) {
    // TODO: implement getTotalTime
    return 10;
  }
}
