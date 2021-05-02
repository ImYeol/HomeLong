import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/proxy/timeDataProxy.dart';
import 'package:homg_long/proxy/wifiApDataProxy.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class WifiSettingCubit extends Cubit<WifiState> {
  LogUtil logUtil = LogUtil();
  String url = 'http://{{ endpoint }}:{{ port }}/register/user/ap';
  WifiConnectionService connectionService;
  StreamSubscription<WifiState> connectionSubscription;

  WifiSettingCubit(WifiConnectionService connectionService)
      : super(WifiDisConnected("Unknonw", "Unknown", TimeData())) {
    this.connectionService = connectionService;
    this.subscribeWifiEvent();
  }

  void subscribeWifiEvent() {
    connectionService.init();
    connectionSubscription = connectionService.onNewData.listen((event) {
      emit(event);
    }, onError: (error) {
      logUtil.logger.e(error);
    }, onDone: () {
      logUtil.logger.d("wifi event stream closed!");
    });
  }

  void unSubscribeWifiEvent() {
    connectionSubscription.cancel();
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
