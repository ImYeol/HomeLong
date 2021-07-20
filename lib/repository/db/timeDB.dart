import 'dart:convert';

import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db/DBHelper.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class TimeDB implements TimeAPI {
  final logUtil = LogUtil();
  final log = Logger("TimeDB");

  @override
  Future<TimeData> getTimeData(int date) async {
    log.info("getTimeData");

    final db = await DBHelper().getDatabase;

    var res = await db
        .query(DBHelper.timeInfoTable, where: 'date = ?', whereArgs: [date]);
    if (res.isEmpty) {
      log.info("getTimeData fail(date:$date):has no timeData");
      return null;
    }

    log.info("res.first=${res.first}");
    log.info("res.first['date']=${res.first['date']}");
    log.info("res.first['timeList']=${res.first['timeList']}");

    var tagsJson = jsonDecode(res.first['timeList']);
    log.info(
        "jsonDecode(res.first['timeList'])=${jsonDecode(res.first['timeList'])}");

    List<Map<String, dynamic>> tags =
        tagsJson != null ? List.from(tagsJson) : null;
    log.info("getTimeData success(date:$date)");

    TimeData _timeData = TimeData.fromJson(tags);
    log.info("timeData.toJson()=${_timeData.toJson()}");

    return _timeData;
  }

  @override
  Future<bool> setTimeData(TimeData timeData) async {
    log.info("setTimeData");

    final db = await DBHelper().getDatabase;

    log.info("timeData.toJson()=${timeData.toJson()}");
    log.info("jsonEncode(timeData)=${jsonEncode(timeData)}");

    var res = await db.rawInsert(
        "INSERT OR REPLACE INTO ${DBHelper.timeInfoTable}(date, timeList, totalMinute) VALUES(?,?,?)",
        [
          getDay(DateTime.now()).toString(),
          jsonEncode(timeData),
          getTotalMinute(timeData)
        ]);

    if (res > 0) {
      log.info("setTimeInfo success + $res");
      return true;
    }

    log.info("setTimeInfo failed + $res");
    return false;
  }

  int getTotalMinute(TimeData timeData) {
    int totalMinuter = 0;
    for (var time in timeData.timeList) {
      totalMinuter += getMinuteBetweenTimes(time.enterTime, time.exitTime);
    }
    return totalMinuter;
  }
}
