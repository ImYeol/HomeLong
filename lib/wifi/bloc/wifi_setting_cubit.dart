import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/ConnectivityServiceWrapper.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/proxy/wifiApDataProxy.dart';

class WifiSettingCubit extends Cubit<WifiState> {
  LogUtil logUtil = LogUtil();
  String url = 'http://{{ endpoint }}:{{ port }}/register/user/ap';
  late ConnectivityServiceWrapper connectionService;
  late StreamSubscription<WifiState> connectionSubscription;

  WifiSettingCubit(ConnectivityServiceWrapper connectionService)
      : super(WifiDisConnected("Unknonw", "Unknown")) {
    this.connectionService = connectionService;
    this.subscribeWifiEvent();
  }

  void subscribeWifiEvent() {
    connectionService.listenWifiStateChanged((state) => emit(state));
    connectionService.checkNowConnectionState();
  }

  void unSubscribeWifiEvent() {
    connectionService.unlistenWifiStateChanged();
  }

  void postWifiAPInfo(String id, String ssid, String bssid) async {
    bool result = await WifiApDataProxy.uploadWifiAPInfo(id, ssid, bssid);
    if (result) {
      emit(WifiInfoSaved(ssid, bssid));
    } else {
      emit(WifiInfoSaveFailed(ssid, bssid));
    }
  }
}
