import 'package:fl_chart/fl_chart.dart';

enum ChartContentType { WEEK, MONTH }

class ChartInfo {
  final double minY;
  final double maxY;
  final double minX;
  final double maxX;
  final double intervalY;
  final double intervalX;
  final String title;
  final ChartContentType chartType;
  final List<BarChartGroupData> chartGroupData;
  ChartInfo(
      {this.minY = 0,
      this.maxY = 10,
      this.minX = 0,
      this.maxX = 10,
      this.intervalX = 1,
      this.intervalY = 8,
      required this.title,
      required this.chartType,
      required this.chartGroupData});
}

class WeekChartInfo extends ChartInfo {
  WeekChartInfo(List<BarChartGroupData> chartGroupData)
      : super(
            maxY: 24,
            maxX: 7,
            title: "Week",
            chartType: ChartContentType.WEEK,
            chartGroupData: chartGroupData);
}

class MonthChartInfo extends ChartInfo {
  MonthChartInfo(List<BarChartGroupData> chartGroupData)
      : super(
            maxY: 24,
            maxX: 30,
            intervalX: 5,
            title: "Month",
            chartType: ChartContentType.MONTH,
            chartGroupData: chartGroupData);
}
