import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:homg_long/counter/bloc/counterCubit.dart';
import 'package:homg_long/counter/view/counterPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/rank/bloc/rankCubit.dart';
import 'package:homg_long/rank/rankPage.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/geofenceRepository.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/screen/model/appScreenState.dart';
import 'package:logging/logging.dart';

class AppScreenCubit extends Cubit<AppScreenState> {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  final LogUtil logUtil = LogUtil();
  final log = Logger("AppScreenCubit");

  var _geofenceRepository = GeofenceRepository();

  int _currentPage = 0;

  // TODO: Will be update 60 seconds(1 minute)
  final period = 60; // second

  InAppUser _userInfo = InAppUser();
  TimeData _timeData = TimeData();

  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();
  var _counterCubit = CounterCubit();

  final _pages = [CounterPage(), RankPage(), RankPage()];
  final _wifiConnectionService = WifiConnectionService.instance;
  bool _userAtHome = false;

  Timer timer;

  AppScreenCubit() : super(PageLoading(CircularProgressIndicator())) {
    _geofenceRepository.updateGeofenceList(
        'home', _userInfo.latitude, _userInfo.longitude);
  }

  int get currentPage => _currentPage;

  // Stream<int> get counterStream => _atHomeCounterStreamController.stream;

  void init() {
    loadUserInfo();
    startGeofenceService();
    startWifiConnectionService();
    // dispatch(currentPage);
  }

  void startWifiConnectionService() {
    // TODO: wifi info is not defined from user. (#47)
    // https://github.com/ImYeol/HomeLong/issues/47
    if (_userInfo.ssid == null || _userInfo.ssid.isEmpty) return;

    log.info("startWifiConnectionService");

    _wifiConnectionService.listenWifiStateChanged(_onWifiStateChanged);
    _wifiConnectionService.checkNowConnectionState();
  }

  void startGeofenceService() {
    // TODO: user doesn't want to allow GPS permission. (#46)
    // https://github.com/ImYeol/HomeLong/issues/46
    if (_userInfo.latitude == double.infinity ||
        _userInfo.longitude == double.infinity) return;

    log.info("startGeofenceService");

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _geofenceRepository.geofenceService
          .addGeofenceStatusChangedListener(_onGeofenceStatusChanged);
      _geofenceRepository.geofenceService
          .addActivityChangedListener(_onActivityChanged);
      _geofenceRepository.geofenceService.addStreamErrorListener(_onError);
      _geofenceRepository.geofenceService
          .start(_geofenceRepository.geofenceList)
          .catchError(_onError);
    });
  }

  bool needForegroundTask() {
    _userInfo = InAppUser();

    if (_userInfo.ssid != null && _userInfo.ssid.isNotEmpty) return true;
    if (_userInfo.latitude.isFinite || _userInfo.longitude.isFinite)
      return true;

    return false;
  }

  void mockGeofenceMethod() {}

  void dispose() {
    _activityStreamController.close();
    _geofenceStreamController.close();
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
        enableCounterIfUserNotAtHome(true);
        break;
      case GeofenceStatus.EXIT:
        enableCounterIfUserNotAtHome(false);
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
    bool enabled = state is WifiConnected;
    enableCounterIfUserNotAtHome(enabled);
  }

  void enableCounterIfUserNotAtHome(bool enabled) {
    // check if Already enabled
    if (enabled == _userAtHome) return;
    if (enabled) {
      startCounter();
    } else {
      stopCounter();
    }
  }

  void _onError(dynamic error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      log.info('Undefined error: $error');
      return;
    }

    log.info('ErrorCode: $errorCode');
  }

  void startCounter() {
    log.info("startCounter");
    if (timer != null) timer.cancel();

    timer = Timer.periodic(Duration(seconds: period), (timer) {
      log.info("onMinuteTimeEvent : " + period.toString());
      var day = DateTime.now().day;
      _counterCubit.addMinute(day, 1);
    });
  }

  void stopCounter() {
    log.info("stopCounter");
    if (timer != null) timer.cancel();
  }

  void loadUserInfo() {
    log.info("userInfo:$_userInfo");
    log.info("timeData:$_timeData");
  }

  saveTimeInfo() {
    DBHelper().setTimeInfo(_timeData);
  }

  void dispatch(int tappedIndex) {
    _currentPage = tappedIndex;
    Widget widget = Container();
    log.info("counter controller closed : ${tappedIndex}");
    switch (tappedIndex) {
      case HOME_PAGE:
        widget = BlocProvider(
          create: (_) => CounterCubit(),
          child: _pages[0],
        );
        emit(HomePageLoaded(widget));
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
}
