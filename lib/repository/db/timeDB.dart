import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:logging/logging.dart';

class TimeDB {
  static final String TIME_DB_NAME = "TimeDB";
  static final String IN_OUT_DB_NAME = "InOutDB";
  static final String ENTER_TIME = "enterTime";
  static final String EXIT_TIME = "exitTime";

  final logUtil = LogUtil();
  final log = Logger("TimeDB");

  void init() {
    Hive.registerAdapter(HomeTimeAdapter());
  }

  Future<bool> openDatabase() async {
    final timeDbBox = Hive.isBoxOpen(TIME_DB_NAME)
        ? Hive.box(TIME_DB_NAME)
        : await Hive.openBox(TIME_DB_NAME);
    final inOutDbBox = Hive.isBoxOpen(IN_OUT_DB_NAME)
        ? Hive.box(IN_OUT_DB_NAME)
        : await Hive.openBox(IN_OUT_DB_NAME);
    return timeDbBox.isOpen && inOutDbBox.isOpen;
  }

  bool registerEnterExitStateChangedListener(void Function() onStateChanged) {
    if (Hive.box(IN_OUT_DB_NAME).isOpen == false) {
      log.info("registerEnterExitStateChangedListener - DB is not opened");
      return false;
    }
    Hive.box(IN_OUT_DB_NAME)
        .listenable(keys: [ENTER_TIME, EXIT_TIME]).addListener(onStateChanged);
    return true;
  }

  void _checkIfDBOpenedOrOpenDB(String db) async {
    if (Hive.box(db).isOpen == false) {
      log.warning("saveEnterTime - box is not opened");
      await Hive.openBox(db);
    }
  }

  void saveEnterTime(DateTime enterTime) async {
    _checkIfDBOpenedOrOpenDB(IN_OUT_DB_NAME);
    await Hive.box(IN_OUT_DB_NAME).put(ENTER_TIME, enterTime.toString());
  }

  void saveExitTime(DateTime exitTime) async {
    _checkIfDBOpenedOrOpenDB(IN_OUT_DB_NAME);
    log.info("saveExitTime - ${exitTime}");
    await Hive.box(IN_OUT_DB_NAME).put(EXIT_TIME, exitTime.toString());
  }

  DateTime getEnterTime() {
    _checkIfDBOpenedOrOpenDB(IN_OUT_DB_NAME);
    final enterTimeString = Hive.box(IN_OUT_DB_NAME).get(ENTER_TIME,
        defaultValue: TimeRepository.INVALID_DATE_TIME) as String;
    return DateTime.parse(enterTimeString);
  }

  DateTime getExitTime() {
    _checkIfDBOpenedOrOpenDB(IN_OUT_DB_NAME);
    final exitTimeString = Hive.box(IN_OUT_DB_NAME).get(EXIT_TIME,
        defaultValue: TimeRepository.INVALID_DATE_TIME) as String;
    return DateTime.parse(exitTimeString);
  }

  void clearEnterAndExitTime() {
    _checkIfDBOpenedOrOpenDB(IN_OUT_DB_NAME);
    Hive.box(IN_OUT_DB_NAME).deleteAll([ENTER_TIME, EXIT_TIME]);
    log.info(
        "clearEnterAndExitTime - enterTime: ${Hive.box(IN_OUT_DB_NAME).get(ENTER_TIME)}");
  }

  void updateHomeTime(
      DateTime enterTime, DateTime exitTime, DateTime targetDay) {
    final homeTime = HomeTime(
        enterTime: enterTime.toString(),
        exitTime: exitTime.toString(),
        description: "home");

    _checkIfDBOpenedOrOpenDB(TIME_DB_NAME);
    log.info("updateHomeTime - targetDay : ${targetDay}");
    List<dynamic> homeTimeList = Hive.box(TIME_DB_NAME)
        .get(targetDay.toString(), defaultValue: <HomeTime>[]);
    log.info("updateHomeTime - list : ${homeTimeList}");
    homeTimeList.add(homeTime);
    Hive.box(TIME_DB_NAME).put(targetDay.toString(), homeTimeList);
  }

  int getTotalMinuteADay(DateTime targetDay) {
    _checkIfDBOpenedOrOpenDB(TIME_DB_NAME);
    int totalMinute = 0;
    final homeTimeList = Hive.box(TIME_DB_NAME)
        .get(targetDay.toString(), defaultValue: <HomeTime>[]);
    homeTimeList.forEach((element) {
      DateTime enterTime = DateTime.parse(element.enterTime);
      DateTime exitTime = DateTime.parse(element.exitTime);
      // inMinute for debug
      totalMinute += exitTime.difference(enterTime).inMinutes;
    });
    log.info(
        "getTotalMinuteADay - total= ${totalMinute} key = ${targetDay}, list : ${homeTimeList}");
    return totalMinute;
  }

  List<HomeTime> getTodayHomeTimeHistory(DateTime targetDay) {
    _checkIfDBOpenedOrOpenDB(TIME_DB_NAME);
    final homeTimeList = Hive.box(TIME_DB_NAME)
        .get(targetDay.toString(), defaultValue: <HomeTime>[]);
    return List<HomeTime>.from(homeTimeList);
  }
}
