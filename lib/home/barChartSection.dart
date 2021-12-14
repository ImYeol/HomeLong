import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/home/barChartContent.dart';
import 'package:homg_long/home/barChartToggleButton.dart';
import 'package:homg_long/home/bloc/chartController.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class BarChartSection extends StatelessWidget {
  final log = Logger("_BarChartSectionState");
  double width = 0;
  double height = 0;
  final controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(child: Obx(() {
      log.info("BarChartSectionState build");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [BarChartToggleButton(), Container(height: 10), barChart()],
      );
    }));
  }

  Widget barChart() {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        width: width,
        child: AspectRatio(
            aspectRatio: 2 / 1,
            child: BarChartContent(chartInfo: controller.chartInfo)));
  }
}
