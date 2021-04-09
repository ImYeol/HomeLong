import 'dart:async';

import 'package:homg_long/repository/model/timeEvent.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CounterService {
  final _onNewData = StreamController<TimeEvent>.broadcast();
  Stream<TimeEvent> get onNewData => _onNewData.stream;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  CounterService();

  void init() {
    stopTimer();
  }

  void dispose() {
    _onNewData.close();
  }

  void startTimer() {
    _stopWatchTimer.minuteTime.listen((value) {
      _onNewData.sink.add(OnMinuteTimeEvent(value));
      print('minuteTime $value');
    });
    _stopWatchTimer.secondTime.listen((value) {
      _onNewData.sink.add(OnHourTimeEvent(value));
      print('secondTime $value');
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    // start
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void stopTimer() async {
    if (_stopWatchTimer.isRunning)
      // Stop
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    //await _stopWatchTimer.dispose();
  }
}
