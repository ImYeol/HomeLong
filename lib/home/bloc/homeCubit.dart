import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/home/model/timeData.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class HomeCubit extends Cubit<HomeState> {
  WifiConnectionService connectionService;
  StreamSubscription<WifiState> connectionSubscription;
  UserInfo userInfo;
  TimeData day = DayTime();
  TimeData week = WeekTime();
  TimeData month = MonthTime();
  Timer timer;

  HomeCubit(WifiConnectionService connectionService) : super(HomeInit()) {
    this.connectionService = connectionService;
  }

  void init() {
    connectionService.init();
    connectionSubscription = connectionService.onNewData.listen((state) {
      if (state is WifiConnected) {
        starCounter();
      } else if (state is WifiDisConnected) {
        stopCounter();
      }
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("wifi event stream closed!");
    });
  }

  void dispose() {
    connectionSubscription.cancel();
  }

  void starCounter() {
    print("startTimer");
    //countSubscription = counterService.onNewData.listen((event) {\
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      day.incrementMinute();
      week.incrementMinute();
      month.incrementMinute();

      print("onMinuteTimeEvent : " +
          day.toString() +
          " / time: " +
          DateTime.now().toString());
      emit(DataLoaded(day, week, month));
    });
  }

  void stopCounter() {
    timer.cancel();
  }

  void updateUserInfo() async {
    userInfo = UserInfo(
        bssid: "00:00:00:00", id: "AAAAA", image: "null", ssid: "android-ap");
    Future.delayed(Duration(seconds: 1), () => emit(UserInfoLoaded()));
  }
}
