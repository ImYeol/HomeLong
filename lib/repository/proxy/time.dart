import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/time.dart';

class TimeProxy implements Time {
  @override
  Future<TimeData> getTimeData(int date) async {
    // TODO: implement getTimeData
    return null;
  }

  @override
  Future<bool> setTimeData(TimeData timeData) async {
    // TODO: implement setTimeData
    return true;
  }
}
