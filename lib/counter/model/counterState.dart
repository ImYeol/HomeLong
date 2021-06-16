import 'package:homg_long/repository/model/timeData.dart';

class CounterState {
  TimeData _timeData = TimeData();

  CounterState({TimeData timeData}) : super() {
    if (timeData != null) {
      this._timeData = timeData;
    }
    _timeData = TimeData();
  }

  CounterState updateState(int date, int minute) {
    _timeData.date = date;
    _timeData.minute = minute;
    return CounterState(timeData: _timeData);
  }

  TimeData getTimeData() {
    return _timeData;
  }
}
