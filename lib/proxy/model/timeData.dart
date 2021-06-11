import 'package:homg_long/log/logger.dart';
import 'package:logging/logging.dart';

class TimeData {
  final logUtil = LogUtil();
  final log = Logger("TimeDate");

  List<int> timeData;
  int today;
  int week;
  int month;

  DateTime prevDate;

  TimeData() {
    today = 0;
    week = 0;
    month = 0;
    prevDate = DateTime.now();
  }

  void toSumOfWeek(List<int> timeData) {
    int size = timeData.length < 7 ? timeData.length : 7;

    for (int i = 0; i < size; i++) {
      week += i;
    }
  }

  void toSumOfMonth(List<int> timeData) {
    int size = timeData.length < 30 ? timeData.length : 30;

    for (int i = 0; i < size; i++) {
      month += i;
    }
  }

  int get _today => today;

  int get _week => week;

  int get _month => month;

  set _timeData(List<int> timeData) {
    this.timeData = timeData;
    toSumOfWeek(timeData);
    toSumOfMonth(timeData);
  }

  set _today(int today) {
    this.today = today;
  }

  set _week(int week) {
    this.week = week;
  }

  set _month(int month) {
    this.month = month;
  }

  factory TimeData.fromJson(List<dynamic> parsed) {
    TimeData data = TimeData();
    data._timeData = parsed.map((item) => item['time']).toList();
    return data;
  }

  int getHour(int time) {
    return (time / 60).floor();
  }

  int getMinute(int time) {
    return time % 60;
  }

  //TODO: day by day update
  void updateTime(int duration) {
    DateTime now = DateTime.now();

    if (prevDate.day != now.day) {
      today = 0;
    } else {
      timeData[now.day] += duration;
      today = timeData[now.day];
    }

    if (prevDate.weekday != now.weekday && now.weekday == DateTime.monday) {
      week = 0;
    } else {
      week += duration;
    }

    if (prevDate.month != now.month) {
      month = 0;
    } else {
      month += duration;
    }

    prevDate = now;
  }

  @override
  String toString() {
    return "today : " +
        today.toString() +
        ", week : " +
        week.toString() +
        ", month : " +
        month.toString();
  }

  String toDayString() {
    return getHour(today).toString() + " : " + getMinute(today).toString();
  }

  String toWeekString() {
    return getHour(week).toString() + " : " + getMinute(week).toString();
  }

  String toMonthString() {
    return getHour(month).toString() + " : " + getMinute(month).toString();
  }

  String toTimeInfoString() {
    StringBuffer result = StringBuffer();
    timeData.map((day) => result.write(day.toString() + ","));

    return result.toString();
  }

  void setFromTimeString(String timeString) {
    log.info("setFromTimeString : ${timeString}");
    if (timeString == null || timeString.isEmpty) {
      log.info("Loaded timeString null");
      timeData = List.generate(31, (index) => 0);
      return;
    }
    List<String> times = timeString.split(",");
    for (int i = 0; i < times.length; i++) {
      log.info("time : ${times[i]}");
      timeData[i] = int.parse(times[i]);
    }
    //timeData = timeString.split(",").map((data) => print("${data}"); int.parse(data)).toList();
  }
}
