import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/counterPageState.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/screen/bloc/abstractPageCubit.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';

class CounterCubit extends Cubit<CouterPageState> with AbstractPageCubit {
  final logUtil = LogUtil();
  static final int period = 1; // 1 second;
  final int TOTAL_MINUTE_A_DAY = 60 * 24;

  UserActionManager userActionManager;
  Timer timer;
  DateTime tickDateTime;

  int atHomeTime = 0;
  int outHomeTime = 0;
  int noDeterminatedTime = 0;

  CounterCubit(UserActionManager userActionManager) : super(PageLoading()) {
    this.userActionManager = userActionManager;
  }

  @override
  void loadPage() {
    tickDateTime = DateTime.now();
    updateTimes(tickDateTime);
    updateUI();
    startCounter();
  }

  @override
  void unloadPage() {
    stopCounter();
  }

  void startCounter() {
    logUtil.logger.d("starTimer");
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      DateTime now = DateTime.now();
      updateTimesIfdayChanged(now);
      updateUiIfMinuteChanged(now);
    });
  }

  void stopCounter() {
    logUtil.logger.d("stopTimer");
    if (timer != null) timer.cancel();
  }

  void updateUI() {
    emit(new CounterTickInvoked(atHomeTime, outHomeTime, noDeterminatedTime));
  }

  void updateTimes(DateTime now) {
    DateTime onTimeToday = DateTime(now.year, now.month, now.day);
    atHomeTime = userActionManager.getTotalTime(DateTime.now());
    outHomeTime = now.difference(onTimeToday).inMinutes;
    noDeterminatedTime = TOTAL_MINUTE_A_DAY - (atHomeTime + outHomeTime);
  }

  void updateTimesIfdayChanged(DateTime now) {
    if (now.day != tickDateTime.day) {
      userActionManager.changeDay();
      updateTimes(now);
    }
  }

  void updateUiIfMinuteChanged(DateTime now) {
    if (now.minute != tickDateTime.minute) {
      if (userActionManager.isUserAtHome()) {
        atHomeTime++;
      } else {
        outHomeTime++;
      }
      noDeterminatedTime++;
    }
    updateUI();
  }
}
