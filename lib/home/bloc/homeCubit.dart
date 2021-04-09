import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/repository/counterService.dart';
import 'package:homg_long/repository/model/timeEvent.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class HomeCubit extends Cubit<HomeState> {
  WifiConnectionService connectionService;
  CounterService counterService;
  StreamSubscription<WifiState> connectionSubscription;
  StreamSubscription<TimeEvent> countSubscription;
  UserInfo userInfo;
  int minuteInDay = 0;
  int hourInDay = 0;
  int minuteInWeek = 0;
  int hourInWeek = 0;
  int minuteInMonth = 0;
  int hourInMonth = 0;

  HomeCubit(
      WifiConnectionService connectionService, CounterService counterService)
      : super(HomeInit()) {
    this.connectionService = connectionService;
    this.counterService = counterService;
  }

  void init() {
    connectionService.init();
    counterService.init();
    connectionSubscription = connectionService.onNewData.listen((state) {
      if(state is WifiConnected) {
        starCounter();
      } else if(state is WifiDisConnected) {
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
    counterService.dispose();
  }

  void starCounter() {
    countSubscription = counterService.onNewData.listen((event) { 
      if(event is OnMinuteTimeEvent) {
        minuteInDay = event.value;
        minuteInMonth++;
        if(minuteInWeek >= 60) {
          minuteInWeek = 0;
          hourInWeek += 1;
        }
        minuteInMonth++;
        if(minuteInMonth >= 60) {
          minuteInMonth = 0;
          hourInMonth += 1;
        }
        
      } else if(event is OnHourTimeEvent) {
        hourInDay = event.value;
      }
      emit(DayTimeChanged(hour: hourInDay, minute: minuteInDay));
      emit(WeekTimeChanged(hour: hourInWeek, minute: minuteInWeek));
      emit(MonthTimeChanged(hour: hourInMonth, minute: minuteInMonth));
    });
    counterService.startTimer();
  }

  void stopCounter() {
    countSubscription.cancel();
    counterService.stopTimer();
  }

  void updateUserInfo() async {
    userInfo = UserInfo(
        bssid: "00:00:00:00", id: "AAAAA", image: "null", ssid: "android-ap");
    Future.delayed(Duration(seconds: 1), () => emit(DataLoaded()));
  }
}
