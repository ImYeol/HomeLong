import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/counter/model/counterState.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/timeData.dart';
import 'package:logging/logging.dart';

class CounterCubit extends Cubit<CounterState> {
  static final CounterCubit _counterCubit = CounterCubit._internal();

  factory CounterCubit() {
    return _counterCubit;
  }

  CounterCubit._internal() : super(CounterState()) {
    this.initTimeInfo();
  }

  final log = Logger("CounterCubit");

  void addMinute(int date, int minute) {
    log.info(
        "addMinute(date:$date,minute:$minute) timeData(${state.getTimeData().getTime()})");
    if (state.getTimeData().date != date) {
      // date is updated.
      this.initTimeInfo();
    } else {
      emit(state.updateState(date, state.getTimeData().minute + minute));
      DBHelper().setTimeInfo(state.getTimeData());
    }
  }

  initTimeInfo() async {
    log.info("initTimeInfo");
    var res = await DBHelper().getTimeInfo(DateTime.now().day);
    if (res != null) {
      DBHelper().setTimeInfo(
          state.getTimeData() != null ? state.getTimeData() : TimeData());
      return;
    }
  }
}
