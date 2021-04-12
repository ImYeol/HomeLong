abstract class TimeData {
  int hour;
  int minute;
  DateTime prevTime;

  TimeData() {
    hour = 0;
    minute = 0;
    prevTime = DateTime.now();
  }

  int get _hour => hour;
  int get _minute => minute;

  set _hour(int hour) {
    this.hour = hour;
  }

  set _minute(int minute) {
    this.minute = minute;
  }

  void incrementMinute();
  bool needReset();
  void reset() {
    hour = 0;
    minute = 0;
  }

  @override
  String toString() {
    return hour.toString() + " : " + minute.toString();
  }
}

class UnknownTime extends TimeData {
  @override
  void incrementMinute() {
    print("UnknownDayTime");
  }

  @override
  bool needReset() {
    return true;
  }
}

class DayTime extends TimeData {
  DayTime() : super();
  @override
  void incrementMinute() {
    if (needReset()) return;
    minute++;
    if (minute >= 60) {
      minute = 0;
      hour++;
    }
  }

  @override
  bool needReset() {
    bool result = false;
    DateTime today = DateTime.now();
    if (prevTime.day != today.day) {
      result = true;
      reset();
    }
    prevTime = today;
    return result;
  }
}

class WeekTime extends TimeData {
  WeekTime() : super();
  @override
  void incrementMinute() {
    if (needReset()) return;
    minute++;
    if (minute >= 60) {
      minute = 0;
      hour++;
    }
  }

  @override
  bool needReset() {
    bool result = false;
    DateTime thisWeek = DateTime.now();
    if ((prevTime.weekday == DateTime.sunday) &&
        (thisWeek.weekday == DateTime.monday)) {
      result = true;
      reset();
    }
    prevTime = thisWeek;
    return result;
  }
}

class MonthTime extends TimeData {
  MonthTime() : super();
  @override
  void incrementMinute() {
    if (needReset()) return;
    minute++;
    if (minute >= 60) {
      minute = 0;
      hour++;
    }
  }

  @override
  bool needReset() {
    bool result = false;
    DateTime thisMonth = DateTime.now();
    if (prevTime.month != thisMonth.month) {
      result = true;
      reset();
    }
    prevTime = thisMonth;
    return result;
  }
}
