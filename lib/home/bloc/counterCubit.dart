import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/model/counterPageState.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/bloc/abstractPageCubit.dart';
import 'package:homg_long/screen/bloc/userActionEventObserver.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class CounterCubit extends Cubit<CouterPageState>
    with AbstractPageCubit, UserActionEventObserver {
  final log = Logger("CounterCubit");
  static final int period = 1; // 1 second;
  static final int TOTAL_MINUTE_A_DAY = 60 * 60 * 24;

  UserActionManager userActionManager;
  Timer? timer;
  DateTime _lastEnterTime = DateTime.parse(TimeRepository.INVALID_DATE_TIME);
  int accumulatedHomeTime = 0;

  CounterCubit(this.userActionManager) : super(CounterPageLoading());

  @override
  void loadPage() {
    log.info("loadPage");
    userActionManager.registerUserActionEventObserver(this);

    final lastEnterTime = TimeRepository().getEnterTime();
    DateTime now = DateTime.now();
    accumulatedHomeTime = TimeRepository().getTotalMinuteADay(now);
    if (lastEnterTime.toString() != TimeRepository.INVALID_DATE_TIME &&
        userActionManager.isUserAtHome()) {
      _lastEnterTime = lastEnterTime;
      updateUiWithDurationSinceLastEnterTime(now);
      startCounter();
    } else {
      emit(new CounterTickInvoked(
          accumulatedHomeTime, TOTAL_MINUTE_A_DAY - accumulatedHomeTime));
    }
  }

  @override
  void unloadPage() {
    log.info("unLoadPage");
    stopCounter();
  }

  void startCounter() {
    log.info("starTimer");
    if (timer != null) timer!.cancel();
    log.info("starTimer222");
    timer = Timer.periodic(Duration(seconds: period), (timer) {
      if (_lastEnterTime.toString() != TimeRepository.INVALID_DATE_TIME &&
          userActionManager.isUserAtHome()) {
        DateTime now = DateTime.now();
        updateLastEnterTimesIfdayChanged(now);
        updateUiWithDurationSinceLastEnterTime(now);
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
      accumulatedHomeTime = 0;
      log.info(
          "updateLastEnterTimesIfdayChanged - midnight: ${todayMidnight}, lastEnter: ${_lastEnterTime}, now: ${now}");
    }
  }

  void updateUiWithDurationSinceLastEnterTime(DateTime now) {
    if (now.isAfter(_lastEnterTime)) {
      Duration durationSinceLastEnterTime = now.difference(_lastEnterTime);
      final inHometime =
          durationSinceLastEnterTime.inSeconds + accumulatedHomeTime;
      final outHomeTime = TOTAL_MINUTE_A_DAY - inHometime;
      emit(new CounterTickInvoked(inHometime, outHomeTime));
      log.info(
          "update UI : inHomeTime = ${inHometime}, outHomeTime = ${outHomeTime} ");
    }
  }

  @override
  void onUserActionChanged(UserActionType action, DateTime time) {
    log.info("onUserActionChanged : action = ${action}, time = ${time} ");
    switch (action) {
      case UserActionType.ENTER_HOME:
        _lastEnterTime = time;
        accumulatedHomeTime =
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
