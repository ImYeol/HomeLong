import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';

class HomeCubit extends Cubit<HomeState> {
  final logUtil = LogUtil();
  Stream<TimeData> counterStream;

  HomeCubit(Stream<TimeData> counterStream) : super(TimeDataLoading()) {
    this.counterStream = counterStream;
  }

  Stream<TimeData> get _counterStream => counterStream;

// void loadTimeData(BuildContext context) {
//   log.info("loadTimeData");
//   listenTimerEvent(connectionService);
//   emit(TimeDataLoaded(connectionService.getCurrentTimeData()));
// }

// void listenTimerEvent(WifiConnectionService connectionService) {
//   connectionSubscription = connectionService.onNewData.listen((state) {
//     log.info("homeCubit : data loaded from service");
//     emit(TimeDataLoaded(state.timeData));
//   }, onError: (error) {
//     logUtil.logger.e(error);
//     emit(TimeDataError(TimeData()));
//   }, onDone: () {
//     log.info("wifi event stream closed!");
//   });
// }

// void dispose() {
//   connectionSubscription.cancel();
// }
}
