import 'package:homg_long/repository/db/timeDB.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:homg_long/repository/proxy/timeProxy.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class TimeRepository {
  static const String INVALID_DATE_TIME = "9999-12-31 00:00:00.000";

  late TimeDB _db;
  late TimeProxy _proxy;
  final log = Logger("TimeRepository");

  static final TimeRepository _instance = TimeRepository._internal();

  factory TimeRepository() {
    return _instance;
  }

  TimeRepository._internal() {
    _db = TimeDB();
    _proxy = TimeProxy();
  }

  void init() {
    _db.init();
  }

  Future<bool> openDatabase() async {
    final isOpened = await _db.openDatabase();
    if (isOpened) {
      _db.registerEnterExitStateChangedListener(onEnterExitStateChanged);
    }
    return _db.openDatabase();
  }

  void onEnterExitStateChanged() {}

  void saveEnterTime(DateTime enterTime) {
    _db.saveEnterTime(enterTime);
  }

  void saveExitTime(DateTime exitTime) {
    final lastEnterTime = _db.getEnterTime();
    log.info(
        "saveExitTime: ${lastEnterTime} : ${exitTime.isAfter(lastEnterTime)}");
    if (lastEnterTime.toString() != INVALID_DATE_TIME &&
        exitTime.isAfter(lastEnterTime)) {
      updateEnterExitBetweenDates(lastEnterTime, exitTime);
      // clear Enter, Exit Time
      clearEnterAndExitTime();
    }
  }

  void clearEnterAndExitTime() {
    _db.clearEnterAndExitTime();
  }

  DateTime getEnterTime() {
    return _db.getEnterTime();
  }

  DateTime getExitTime() {
    return _db.getExitTime();
  }

  void updateEnterExitBetweenDates(DateTime enterTime, DateTime exitTime) {
    if (enterTime.day == exitTime.day) {
      _db.updateHomeTime(enterTime, exitTime, getDateTimeAsSameDay(exitTime));
    } else {
      DateTime midNightOfEnterTime =
          getDateTimeAsSameDay(enterTime.add(Duration(days: 1)));
      _db.updateHomeTime(
          enterTime, midNightOfEnterTime, getDateTimeAsSameDay(enterTime));
      // start at 00:00 a day after enterTime
      for (DateTime date = midNightOfEnterTime;
          date.isBefore(exitTime);
          date = date.add(Duration(days: 1))) {
        if (date.day == exitTime.day) {
          log.info(
              "updateHomeTimeDurationOfHome : date == exitDate ${date} : ${exitTime}");
          _db.updateHomeTime(date, exitTime, getDateTimeAsSameDay(date));
          break;
        } else {
          log.info(
              "updateHomeTimeDurationOfHome : interval ${date} : ${date.add(Duration(days: 1))}");
          _db.updateHomeTime(
              date, date.add(Duration(days: 1)), getDateTimeAsSameDay(date));
        }
      }
    }
  }

  int getTotalMinuteADay(DateTime targetDay) {
    targetDay = getDateTimeAsSameDay(targetDay);
    return _db.getTotalMinuteADay(targetDay);
  }

  List<HomeTime> getTodayHomeTimeHistory(DateTime date) {
    DateTime today = getDateTimeAsSameDay(date);
    return _db.getTodayHomeTimeHistory(today);
  }
}
