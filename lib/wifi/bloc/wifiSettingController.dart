import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/ConnectivityServiceWrapper.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/proxy/wifiApDataProxy.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';

class WifiSettingController extends GetxController {
  LogUtil logUtil = LogUtil();
  String url = 'http://{{ endpoint }}:{{ port }}/register/user/ap';
  final Rx<WifiState> wifiState = WifiState(ssid: '', bssid: '').obs;

  WifiSettingController();

  void subscribeWifiEvent() {
    UserActionManager().registerWifiStateChangeEventObserver((state) {
      wifiState.value = state;
    });
  }

  void checkCurrentWifiInfo() {
    UserActionManager().checkNowConnectionState();
  }

  void unSubscribeWifiEvent() {
    UserActionManager().unRegisterWifiStateChangeEventObserver();
  }

  void postWifiAPInfo(String id, String ssid, String bssid) async {
    bool result = await WifiApDataProxy.uploadWifiAPInfo(id, ssid, bssid);
  }

  void updateWifiInfo(String ssid, String bssid) async {
    await UserRepository().updateWifiInfo(ssid, bssid);
  }
}
