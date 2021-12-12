import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:homg_long/home/model/chartInfo.dart';
import 'package:homg_long/home/model/counterPageState.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/bloc/abstractPageCubit.dart';
import 'package:homg_long/screen/bloc/userActionEventObserver.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class CounterController extends GetxController with UserActionEventObserver {
  final log = Logger("CounterController");
  static final int period = 1; // 1 second;

  Timer? timer;
  DateTime _lastEnterTime = DateTime.parse(TimeRepository.INVALID_DATE_TIME);
  var accumulatedHomeTime = 0.obs;

  CounterController();

  void loadCounter() async {
    UserActionManager().registerUserActionEventObserver(this);
    UserActionManager().checkNowConnectionState();
    DateTime now = DateTime.now();
    DateTime lastEnterTime = TimeRepository().getEnterTime();
    accumulatedHomeTime.value = TimeRepository().getTotalMinuteADay(now);
    log.info(
        "loadCounter lastEnterTime=${lastEnterTime}, userAtHome=${UserActionManager().isUserAtHome()}");
    if (UserActionManager().isUserAtHome()) {
      _lastEnterTime = lastEnterTime;
      updateDurationSinceLastEnterTime(now);
      startCounter();
    }
    //update();
  }

  void unLoadCounter() async {
    log.info("unLoadCounter");
    stopCounter();
  }

  void startCounter() {
    log.info("starTimer");
    if (timer != null) timer!.cancel();
    log.info("starTimer222");
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      if (_lastEnterTime.toString() != TimeRepository.INVALID_DATE_TIME &&
          UserActionManager().isUserAtHome()) {
        DateTime now = DateTime.now();
        updateLastEnterTimesIfdayChanged(now);
        accumulatedHomeTime.value += 1;
      }
    });
  }

  void stopCounter() {
    log.info("stopTimer ${timer?.isActive}");
    if (timer != null && timer!.isActive) timer?.cancel();
  }

  void updateLastEnterTimesIfdayChanged(DateTime now) {
    if (now.day != _lastEnterTime.day) {
      final todayMidnight = getDateTimeAsSameDay(now);
      TimeRepository().saveExitTime(todayMidnight);
      TimeRepository().saveEnterTime(todayMidnight);
      _lastEnterTime = todayMidnight;
      accumulatedHomeTime.value = 0;
      log.info(
          "updateLastEnterTimesIfdayChanged - midnight: ${todayMidnight}, lastEnter: ${_lastEnterTime}, now: ${now}");
    }
  }

  void updateDurationSinceLastEnterTime(DateTime now) {
    if (now.isAfter(_lastEnterTime)) {
      Duration durationSinceLastEnterTime = now.difference(_lastEnterTime);
      accumulatedHomeTime.value =
          durationSinceLastEnterTime.inSeconds + accumulatedHomeTime.value;
      log.info("update UI : accumulatedHomeTime = ${accumulatedHomeTime}");
    }
  }

  @override
  void onUserActionChanged(UserActionType action, DateTime time) {
    log.info("onUserActionChanged : action = ${action}, time = ${time} ");
    switch (action) {
      case UserActionType.ENTER_HOME:
        _lastEnterTime = time;
        accumulatedHomeTime.value =
            TimeRepository().getTotalMinuteADay(_lastEnterTime);
        startCounter();
        break;
      case UserActionType.EXIT_HOME:
        _lastEnterTime = DateTime.parse(TimeRepository.INVALID_DATE_TIME);
        stopCounter();
        break;
    }
  }
}
