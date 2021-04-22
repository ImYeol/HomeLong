import 'dart:convert';

import 'package:homg_long/proxy/timeDataProxy.dart';

class TimeData {
  List<int> timeData;
  int today;
  int week;
  int month;

  TimeData() {}

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

  void updateTime(int duration) {
    today += duration;
    week += duration;
    month += duration;
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
}
