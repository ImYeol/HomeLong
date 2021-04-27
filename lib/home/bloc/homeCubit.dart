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
  StreamSubscription<WifiState> connectionSubscription;

  HomeCubit() : super(TimeDataLoading());

  void loadTimeData(BuildContext context) {
    if (!(this.state is TimeDataLoading)) emit(TimeDataLoading());
    listenTimerEvent(context.read<WifiConnectionService>());
  }

  void listenTimerEvent(WifiConnectionService connectionService) {
    connectionSubscription = connectionService.onNewData.listen((state) {
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
