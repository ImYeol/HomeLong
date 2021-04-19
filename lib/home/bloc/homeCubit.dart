import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
<<<<<<< HEAD
import 'package:homg_long/home/model/timeData.dart';
import 'package:homg_long/repository/model/UserInfo.dart';
=======
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/proxy/timeDataProxy.dart';
import 'package:homg_long/repository/model/userInfo.dart';
>>>>>>> 2ed1030 (add proxy)
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:http/http.dart' as http;

class HomeCubit extends Cubit<HomeState> {
  WifiConnectionService connectionService;
  StreamSubscription<WifiState> connectionSubscription;
  UserInfo userInfo;
  TimeData day = DayTime(0, 0);
  TimeData week = WeekTime(0, 0);
  TimeData month = MonthTime(0, 0);
  Timer timer;

  HomeCubit(WifiConnectionService connectionService) : super(HomeInit()) {
    this.connectionService = connectionService;
    init();
  }

  void loadTimeData(UserInfo userInfo) async {
    emit(DataLoading(UnknownTime(), UnknownTime(), UnknownTime()));

    List<TimeData> parsedData = await TimeDataProxy.fetchAllTimeData(
        userInfo.id, TimeDataProxy.DataTypeAll);
    day.copyOf(parsedData[0]);
    week.copyOf(parsedData[1]);
    month.copyOf(parsedData[2]);

    emit(DataLoaded(day, week, month));
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
