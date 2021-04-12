import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class WifiSettingCubit extends Cubit<WifiState> {
  WifiConnectionService connectionService;
  StreamSubscription<WifiState> connectionSubscription;

  WifiSettingCubit(WifiConnectionService connectionService)
      : super(WifiDisConnected(null, null)) {
    this.connectionService = connectionService;
  }

  void subscribeWifiEvent() {
    connectionService.init();
    connectionSubscription = connectionService.onNewData.listen((event) {
      emit(event);
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("wifi event stream closed!");
    });
  }

  void unSubscribeWifiEvent() {
    connectionSubscription.cancel();
  }
}
