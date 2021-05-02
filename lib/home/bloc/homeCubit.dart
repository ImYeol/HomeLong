import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

class HomeCubit extends Cubit<HomeState> {
  final logUtil = LogUtil();
  StreamSubscription<WifiState> connectionSubscription;

  HomeCubit() : super(TimeDataLoading());

  void loadTimeData(BuildContext context) {
    WifiConnectionService connectionService =
        context.watch<WifiConnectionService>();
    logUtil.logger.d("loadTimeData");
    listenTimerEvent(connectionService);
    emit(TimeDataLoaded(connectionService.getCurrentTimeData()));
  }

  void listenTimerEvent(WifiConnectionService connectionService) {
    connectionSubscription = connectionService.onNewData.listen((state) {
      logUtil.logger.d("homeCubit : data loaded from service");
      emit(TimeDataLoaded(state.timeData));
    }, onError: (error) {
      logUtil.logger.e(error);
      emit(TimeDataError(TimeData()));
    }, onDone: () {
      logUtil.logger.d("wifi event stream closed!");
    });
  }

  void dispose() {
    connectionSubscription.cancel();
  }
}
