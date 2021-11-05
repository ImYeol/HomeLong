import 'package:homg_long/repository/model/time.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class TimeData {
  List<Time> timeList = <Time>[];
  final log = Logger("TimeData");

  TimeData();

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> localList = [];
    for (int i = 0; i < this.timeList.length; i++) {
      localList.add(this.timeList[i].toJson());
    }
    return localList;
  }

  TimeData.fromJson(List<Map<String, dynamic>> json) {
    for (int i = 0; i < json.length; i++) {
      Time t = Time.fromJson(json[i]);
      this.timeList.add(t);
    }
  }

  bool updateEnterTime(int enterTime) {
    if (timeList.length == 0 || timeList.last.exitTime > 0) {
      log.info("updateEnterTime: add ${enterTime}");
      this.timeList.add(Time(enterTime: enterTime));
      return true;
    }
    log.info("updateEnterTime: failed to add ${enterTime}");
    return false;
  }

  bool updateExitTime(int exitTime) {
    if (timeList.length == 0 || timeList.last.enterTime == 0) {
      log.info("updateExitTime : empty list - ${exitTime}");
      updateEnterTime(Time.INIT_TIME_OF_A_DAY);
    }
    log.info("updateExitTime : add ${exitTime}");
    this.timeList.last.exitTime = exitTime;
    return true;
  }

  int getTotalTime(DateTime now, bool isAtHome) {
    int totalTime = 0;
    int diff = 0;
    this.timeList.forEach((time) {
      log.fine(
          "getTotalTime: ${time} - now: ${getTime(now)} - isAtHome: ${isAtHome}");
      if (time.exitTime <= 0) {
        diff = getTimeDiffInSeconds(getTime(now), time.enterTime);
        totalTime += isAtHome ? diff : 0;
        log.fine("getTotalTime exit=0 : diff - ${diff}");
      } else {
        diff = getTimeDiffInSeconds(time.exitTime, time.enterTime);
        log.fine("getTotalTime: diff - ${diff}");
        totalTime += diff;
      }
    });
    return totalTime;
  }
}
