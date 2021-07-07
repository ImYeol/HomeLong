import 'package:homg_long/repository/model/time.dart';
import 'package:logging/logging.dart';

class TimeData {
  List<Time> timeList = List<Time>();
  final log = Logger("TimeData");

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> localList = List();
    for (int i = 0; i < this.timeList.length; i++) {
      localList.add(this.timeList[i].toJson());
    }
    return localList;
  }

  void fromJson(List<Map<String, dynamic>> json) {
    for (int i = 0; i < json.length; i++) {
      Time t = Time.fromJson(json[i]);
      this.timeList.add(t);
    }
  }

  void updateEnterTime(int enterTime) {
    this.timeList.add(Time(enterTime: enterTime));
  }

  void updateExitTime(int exitTime) {
    int lastEnterTime =
        this.timeList.isEmpty ? "000000" : this.timeList.last.enterTime;
    this.timeList.last = Time(enterTime: lastEnterTime, exitTime: exitTime);
  }
}
