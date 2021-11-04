import 'package:homg_long/repository/model/timeData.dart';
import 'package:homg_long/repository/timeRepository.dart';

class TimeProxy implements TimeAPI {
  @override
  Future<TimeData> getTimeData(int date) async {
    // TODO: implement getTimeData
    return TimeData();
  }

  @override
  Future<bool> setTimeData(TimeData timeData) async {
    // TODO: implement setTimeData
    return true;
  }
}
