import 'dart:convert';

import 'package:homg_long/proxy/timeDataProxy.dart';
import 'package:homg_long/log/logger.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TimeData {
  final logUtil = LogUtil();

  List<int> timeData = List.filled(31, 0);

  TimeData({this.timeData});

  factory TimeData.fromJson(Map<int, dynamic> parsed) {
    List<int> timeList = parsed.values.toList();
    return TimeData(timeData: timeList);
  }

  int getHour(int time) {
    return (time / 60).floor();
  }

  int getMinute(int time) {
    return time % 60;
  }
}
