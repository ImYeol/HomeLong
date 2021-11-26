import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/home/model/chartInfo.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:logging/logging.dart';

class ChartController extends GetxController {
  final log = Logger("CounterController");
  static const int daysPerMonth = 30;
  ChartContentType _chartType = ChartContentType.WEEK;
  var _chartInfo = ChartInfo(
          chartGroupData: <BarChartGroupData>[],
          chartType: ChartContentType.WEEK,
          title: "Weekly")
      .obs;

  ChartContentType get selectedChartType => _chartType;
  ChartInfo get chartInfo => _chartInfo.value;

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

  void loadTimeData() async {
    DateTime today = DateTime.now();
    switch (_chartType) {
      case ChartContentType.WEEK:
        loadWeekTimeData(today);
        break;
      case ChartContentType.MONTH:
        loadMonthTimeData(today);
        break;
    }
  }

  void loadWeekTimeData(DateTime today) {
    log.info("loadWeekTimeData");
    _chartType = ChartContentType.WEEK;
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
    _chartInfo.value = WeekChartInfo(weekTimeDataGroup);
  }

  void loadMonthTimeData(DateTime today) {
    log.info("loadMonthTimeData");
    _chartType = ChartContentType.MONTH;
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
    _chartInfo.value = MonthChartInfo(monthTimeDataGroup);
  }

  String toChartTypeString(ChartContentType type) {
    switch (type) {
      case ChartContentType.WEEK:
        return "Weekly";
      case ChartContentType.MONTH:
        return "Monthly";
    }
  }
}
