import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/counterPageState.dart';
import 'package:homg_long/screen/bloc/abstractPageCubit.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:logging/logging.dart';

class CounterCubit extends Cubit<CouterPageState> with AbstractPageCubit {
  final log = Logger("CounterCubit");
  static final int period = 1; // 1 second;
  static final int TOTAL_MINUTE_A_DAY = 60 * 60 * 24;

  UserActionManager userActionManager;
  Timer timer;
  DateTime tickDateTime;

  int atHomeTime = 0;
  int outHomeTime = 0;

  CounterCubit(UserActionManager userActionManager)
      : super(CounterPageLoading()) {
    this.userActionManager = userActionManager;
  }

  @override
  void loadPage() {
    log.info("loadPage");
    tickDateTime = DateTime.now();
    updateTimes(tickDateTime);
    startCounter();
  }

  @override
  void unloadPage() {
    log.info("unLoadPage");
    stopCounter();
  }

  void startCounter() {
    log.info("starTimer");
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      DateTime now = DateTime.now();
      updateTimesIfdayChanged(now);
      updateUiIfMinuteChanged(now);
      tickDateTime = now;
    });
  }

  void stopCounter() {
    log.info("stopTimer ${timer.isActive}");
    if (timer != null && timer.isActive) timer.cancel();
  }

  void updateUI() {
    log.info("updateUI");
    emit(new CounterTickInvoked(atHomeTime, outHomeTime));
  }

  void updateTimes(DateTime now) async {
    log.info("updateTimes : ${now}");
    atHomeTime = await userActionManager.getTotalTime(now);
    outHomeTime = TOTAL_MINUTE_A_DAY - atHomeTime;
    updateUI();
    log.info("updateTimes - atHomeTime: " +
        atHomeTime.toString() +
        " outHomeTime: " +
        outHomeTime.toString());
  }

  void updateTimesIfdayChanged(DateTime now) {
    if (now.day != tickDateTime.day) {
      log.info(
          "updateTimesIfdayChanged - atHomeTime: ${atHomeTime}, outHomeTime: ${outHomeTime}");
      userActionManager.changeDay();
      updateTimes(now);
    }
  }

  void updateUiIfMinuteChanged(DateTime now) {
    if (now.second != tickDateTime.second) {
      //log.info("updateUiIfMinuteChanged - ${userActionManager.isUserAtHome()}");
      if (userActionManager.isUserAtHome()) {
        atHomeTime++;
        outHomeTime--;
        updateUI();
      }
    }
  }
}
