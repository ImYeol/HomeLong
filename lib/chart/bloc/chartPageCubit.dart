import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/chart/chart.dart';
import 'package:homg_long/chart/chartContainer.dart';
import 'package:homg_long/chart/models/chartInfo.dart';
import 'package:homg_long/chart/models/chartPageState.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/screen/bloc/abstractPageCubit.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:logging/logging.dart';

class ChartPageCubit extends Cubit<ChartPageState> with AbstractPageCubit {
  final log = Logger('ChartPageCubit');
  static const int daysPerMonth = 30;
  UserActionManager userActionManager;
  List<bool> buttonSelected = [true, false];

  get isSelected => buttonSelected;

  ChartPageCubit(this.userActionManager) : super(ChartPageLoading());

  BarChartGroupData makeGroupData(
    int x,
    int y, {
    bool isTouched = false,
    Color barColor = Colors.red,
    double width = 10,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y.toDouble() % 10,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  @override
  void loadPage() {
    DateTime today = DateTime.now();
    log.info("loadPage : " + today.toString());
    loadWeekTimeData(today);
  }

  void loadWeekTimeData(DateTime today) async {
    List<BarChartGroupData> weekTimeDataGroup = <BarChartGroupData>[];
    for (int offset = DateTime.daysPerWeek - 1; offset >= 0; offset--) {
      DateTime date = today.subtract(Duration(days: offset));
      int totalTime = TimeRepository().getTotalMinuteADay(date);
      log.info("loadWeekTimeData : " +
          "date=" +
          (date.month * 100 + date.day).toString() +
          " totalTime=" +
          totalTime.toString());
      weekTimeDataGroup
          .add(makeGroupData(date.month * 100 + date.day, totalTime));
    }
    // left side : 0 hours ~ 24 hours
    emit(ChartPageLoaded(chartInfo: WeekChartInfo(weekTimeDataGroup)));
  }

  void loadMonthTimeData(DateTime today) async {
    List<BarChartGroupData> monthTimeDataGroup = <BarChartGroupData>[];
    for (int offset = daysPerMonth - 1; offset >= 0; offset--) {
      DateTime date = today.subtract(Duration(days: offset));
      int totalTime = TimeRepository().getTotalMinuteADay(date);
      log.info("loadWeekTimeData : " +
          "date=" +
          (date.month * 100 + date.day).toString() +
          " totalTime=" +
          totalTime.toString());
      monthTimeDataGroup
          .add(makeGroupData(date.month * 100 + date.day, totalTime));
    }
    // left side : 0 hours ~ 24 hours
    emit(ChartPageLoaded(chartInfo: MonthChartInfo(monthTimeDataGroup)));
  }

  void requestChartUpdated(int selected) {
    DateTime today = DateTime.now();
    log.info("select chart : ${selected}");
    // set false to all
    for (int index = 0; index < buttonSelected.length; index++) {
      buttonSelected[index] = false;
    }
    // set selected item as true
    buttonSelected[selected] = true;
    if (selected == 0) {
      loadWeekTimeData(today);
    } else if (selected == 1) {
      loadMonthTimeData(today);
    }
  }

  @override
  void unloadPage() {}
}
