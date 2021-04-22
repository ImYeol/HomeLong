import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:http/http.dart' as http;

class HomeCubit extends Cubit<HomeState> {
  WifiConnectionService connectionService;
  StreamSubscription<WifiState> connectionSubscription;
  Timer timer;
  TimeData userTimeData;
  BuildContext context;

  HomeCubit(WifiConnectionService connectionService) : super(HomeInit()) {
    this.connectionService = connectionService;
    //init();
  }

  // void loadTimeData(UserInfo userInfo) async {
  //   emit(DataLoading(UnknownTime(), UnknownTime(), UnknownTime()));

  //   List<TimeData> parsedData = await TimeDataProxy.fetchAllTimeData(
  //       userInfo.id, TimeDataProxy.DataTypeAll);
  //   day.copyOf(parsedData[0]);
  //   week.copyOf(parsedData[1]);
  //   month.copyOf(parsedData[2]);

  //   emit(DataLoaded(day, week, month));
  // }

  void init(BuildContext context) {
    this.context = context;
    connectionService.init();
    userTimeData = context.read<AuthenticationRepository>().user.timeInfo;
  }

  void listenTimerEvent() {
    connectionSubscription = connectionService.onNewData.listen((state) {
      if (state is WifiConnected) {
        TimeData timeData = TimeData();
        timeData._today = userTimeData.today + state.duration;
        emit(TimeDataLoaded(timeData));
      } else if (state is WifiDisConnected) {
        stopCounter();
      }
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("wifi event stream closed!");
    });
  }

  void updateCurrentTimeData() {
    context.read<AuthenticationRepository>().
  }

  void dispose() {
    connectionSubscription.cancel();
  }
}
