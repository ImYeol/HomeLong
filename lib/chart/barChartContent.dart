import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homg_long/chart/models/chartInfo.dart';
import 'package:logging/logging.dart';

class BarChartContent extends StatelessWidget {
  final log = Logger("BarChartContent");
  ChartInfo chartInfo;

  BarChartContent({Key? key, required this.chartInfo});
  @override
  Widget build(BuildContext context) {
    log.info("min Y: ${chartInfo.minY}, max Y: ${chartInfo.maxY}");
    return BarChart(BarChartData(
      minY: chartInfo.minY,
      maxY: chartInfo.maxY,
      // bottom data titles
      titlesData: getTitlesData(),
      barGroups: chartInfo.chartGroupData,
      // border line
      borderData:
          FlBorderData(border: Border.all(color: Colors.black, width: 0.5)),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine:
            chartInfo.chartType == ChartContentType.MONTH ? true : false,
        verticalInterval: 3,
      ),
      // alignment for bar rods
      alignment: chartInfo.chartType == ChartContentType.MONTH
          ? BarChartAlignment.end
          : BarChartAlignment.spaceEvenly,
    ));
  }

  SideTitles getBottomTitles() {
    return SideTitles(
      interval: chartInfo.intervalX,
      showTitles: true,
      getTextStyles: (context, value) => const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
      getTitles: (double value) {
        int month = (value / 100).toInt();
        int day = (value % 100).toInt();
        return month.toString() + "." + day.toString();
      },
    );
  }

  SideTitles getLeftTitles() {
    return SideTitles(
      // show Y value with interval 4
      interval: chartInfo.intervalY,
      showTitles: true,
      getTextStyles: (context, value) => const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
      getTitles: (double value) {
        return value.toInt().toString();
      },
    );
  }

  FlTitlesData getTitlesData() {
    return FlTitlesData(
        show: true,
        bottomTitles: getBottomTitles(),
        leftTitles: getLeftTitles());
  }
}
