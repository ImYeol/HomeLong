import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/repository/counterService.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class HomeCubit extends Cubit<HomeState> {
  WifiConnectionService connectionService;
  CounterService counterService;
  StreamSubscription<HomeState> connectionSubscription;
  UserInfo userInfo;

  HomeCubit(
      WifiConnectionService connectionService, CounterService counterService)
      : super(DataLoading()) {
    this.connectionService = connectionService;
  }

  void dispose() {
    connectionSubscription.cancel();
  }

  void updateUserInfo() async {
    userInfo = UserInfo(
        bssid: "00:00:00:00", id: "AAAAA", image: "null", ssid: "android-ap");
    Future.delayed(Duration(seconds: 1), () => emit(DataLoaded()));
  }
}
