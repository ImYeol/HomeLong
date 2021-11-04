import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:homg_long/chart/chart.dart';
import 'package:homg_long/chart/chartContainer.dart';
import 'package:homg_long/chart/models/chartInfo.dart';

class ChartPageState {}

class ChartPageLoading extends ChartPageState {}

class ChartPageLoaded extends ChartPageState {
  final ChartInfo chartInfo;

  ChartPageLoaded({required this.chartInfo});
}
