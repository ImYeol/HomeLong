import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription<WifiState> connectionSubscription;

  HomeCubit() : super(TimeDataLoading());

  void loadTimeData(BuildContext context) {
    WifiConnectionService connectionService =
        context.watch<WifiConnectionService>();
    print("loadTimeData");
    listenTimerEvent(connectionService);
    emit(TimeDataLoaded(connectionService.getCurrentTimeData()));
  }

  void listenTimerEvent(WifiConnectionService connectionService) {
    connectionSubscription = connectionService.onNewData.listen((state) {
      print("homeCubit : data loaded from service");
      emit(TimeDataLoaded(state.timeData));
    }, onError: (error) {
      print(error);
      emit(TimeDataError(TimeData()));
    }, onDone: () {
      print("wifi event stream closed!");
    });
  }

  void dispose() {
    connectionSubscription.cancel();
  }
}
