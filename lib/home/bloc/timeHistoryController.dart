import 'package:get/get.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:homg_long/repository/timeRepository.dart';

class TimeHistoryController extends GetxController {
  var _timeHistory = <HomeTime>[].obs;

  List<HomeTime> get timeHistory => _timeHistory;

  void loadTimeHistoryData() async {
    print("loadTimeHistoryData");
    _timeHistory.value =
        TimeRepository().getTodayHomeTimeHistory(DateTime.now());
  }
}
