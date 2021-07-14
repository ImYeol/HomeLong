import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

showToast(String msg) {
  Fluttertoast.showToast(
    msg: "$msg",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blue[100],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

int getDay(DateTime time) {
  return time.year * 10000 + time.month * 100 + time.day;
}

int getTime(DateTime time) {
  return time.hour * 10000 + time.minute * 100 + time.second;
}

DateTime getOnTime(DateTime time) {
  DateTime onTime = DateTime(time.year, time.month, time.day);
  return onTime;
}

// HHMMSS -> HH
int getHour(int time) {
  return (time / 10000).floor();
}

// HHMMSS -> 00HHMM - 00HH00 = 0000MM
int getMinute(int time) {
  return (time / 100).floor() - ((time / 10000).floor() * 100);
}

// HHMMSS -> HHMMSS - HHMM00 = 0000SS
int getSecond(int time) {
  return time - ((time / 100).floor() * 100);
}

int toSeconds(int time) {
  // var log = Logger("utils");
  // log.info("toSeconds: time - ${time}");
  // log.info("toSeconds: hour - ${getHour(time)}");
  // log.info("toSeconds: minute - ${getMinute(time)}");
  // log.info("toSeconds: seconds - ${getSecond(time)}");
  return getHour(time) * 3600 + getMinute(time) * 60 + getSecond(time);
}

int getTimeDiffInMinute(int time1, int time2) {
  return ((toSeconds(time1) - toSeconds(time2)) / 60).floor().abs();
}

int getTimeDiffInSeconds(int time1, int time2) {
  // var log = Logger("utils");
  // log.info("toSeconds: time1 seconds - ${getSecond(time1)}");
  // log.info("toSeconds: time2 seconds - ${getSecond(time2)}");
  return (toSeconds(time1) - toSeconds(time2)).abs();
}
