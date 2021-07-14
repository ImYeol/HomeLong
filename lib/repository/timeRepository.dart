import 'package:homg_long/repository/db/timeDB.dart';
import 'package:homg_long/repository/proxy/timeProxy.dart';

import 'model/timeData.dart';

abstract class TimeAPI {
  Future<bool> setTimeData(TimeData timeData);
  Future<TimeData> getTimeData(int date);
}

class TimeRepository extends TimeAPI {
  TimeDB _db;
  TimeProxy _proxy;

  static final TimeRepository _instance = TimeRepository._internal();

  factory TimeRepository() {
    return _instance;
  }

  TimeRepository._internal() {
    _db = TimeDB();
    _proxy = TimeProxy();
  }

  @override
  Future<TimeData> getTimeData(int date) async {
    TimeData timeData = await _db.getTimeData(date);
    if (timeData != null) {
      return timeData;
    }
    return await _proxy.getTimeData(date);
  }

  @override
  Future<bool> setTimeData(TimeData timeData) async {
    return await _db.setTimeData(timeData) ||
        await _proxy.setTimeData(timeData);
  }
}
