import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/home/homePage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/rank/bloc/rankCubit.dart';
import 'package:homg_long/rank/rankPage.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/screen/model/appScreenState.dart';

class AppScreenCubit extends Cubit<AppScreenState> {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  final LogUtil logUtil = LogUtil();
  int _currentPage = 0;
  final period = 5; // second
  InAppUser _userInfo;
  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();
  var _atHomeCounterStreamController = StreamController<TimeData>();

  final _geofenceService = GeofenceService.instance.setup(
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

  final _pages = [HomePage(), RankPage(), RankPage()];
  final _wifiConnectionService = WifiConnectionService.instance;
  bool _userAtHome = false;
  TimeData timeData = TimeData();
  Timer timer;

  AppScreenCubit() : super(PageLoading(CircularProgressIndicator()));

  int get currentPage => _currentPage;
  GeofenceService get geofenceService => _geofenceService;
  Stream<TimeData> get counterStream => _atHomeCounterStreamController.stream;

  void init() {
    loadUserInfo();
    startGeofenceService();
    startWifiConnectionService();
    dispatch(currentPage);
  }

  void startWifiConnectionService() {
    if (_userInfo.ssid == null || _userInfo.ssid.isEmpty) return;

    logUtil.logger.d("init Wifi service");
    _wifiConnectionService.listenWifiStateChanged(_onWifiStateChanged);
    _wifiConnectionService.checkNowConnectionState();
  }

  void startGeofenceService() {
    if (_userInfo.latitude == double.infinity ||
        _userInfo.longitude == double.infinity) return;

    logUtil.logger.d("init geofence service");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _geofenceService
          .addGeofenceStatusChangedListener(_onGeofenceStatusChanged);
      _geofenceService.addActivityChangedListener(_onActivityChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(_geofenceList).catchError(_onError);
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

  void mockGeofenceMethod() {}

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
    logUtil.logger.d('geofence: ${geofence.toMap()}');
    logUtil.logger.d('geofenceRadius: ${geofenceRadius.toMap()}');
    logUtil.logger.d('geofenceStatus: ${geofenceStatus.toString()}\n');

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
    logUtil.logger.d('prevActivity: ${prevActivity.toMap()}');
    logUtil.logger.d('currActivity: ${currActivity.toMap()}\n');
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
      logUtil.logger.d('Undefined error: $error');
      return;
    }

    logUtil.logger.d('ErrorCode: $errorCode');
  }

  void startCounter() {
    logUtil.logger.d("startTimer : ${timeData.timeData == null}");
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      timeData.updateTime(period);
      logUtil.logger.d("onMinuteTimeEvent : " + period.toString());
      _atHomeCounterStreamController.sink.add(timeData);
    });
  }

  void stopCounter() {
    logUtil.logger.d("stopTimer");
    if (timer != null) timer.cancel();
  }

  bool loadUserInfo() {
    // load user info
    DBHelper().getUser();
    _userInfo = InAppUser();
    logUtil.logger.d("user : $_userInfo");
    timeData.setFromTimeString(InAppUser().timeInfo);
    logUtil.logger.d("loadUserInfo : " + _userInfo?.toString());
    return true;
  }

  bool saveTimeInfo() {
    DBHelper().updateTimeInfo(timeData.toTimeInfoString());
    return true;
  }

  void dispatch(int tappedIndex) {
    _currentPage = tappedIndex;
    Widget widget = Container();
    logUtil.logger.d("counter controller closed : ${tappedIndex}");
    switch (tappedIndex) {
      case HOME_PAGE:
        _atHomeCounterStreamController.close();
        _atHomeCounterStreamController = StreamController<TimeData>();
        logUtil.logger.d("counter controller closed");
        widget = BlocProvider(
          create: (_) => HomeCubit(_atHomeCounterStreamController.hasListener
              ? null
              : _atHomeCounterStreamController.stream),
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
