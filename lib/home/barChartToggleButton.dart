import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/bloc/chartController.dart';
import 'package:homg_long/home/model/chartInfo.dart';

class BarChartToggleButton extends StatelessWidget {
  final double fontSize = 15;
  final FontWeight fontWeight = FontWeight.w600;
  final Color selectedColor = Colors.white;
  final Color unSelectedColor = Color(0xFFE9E9FF);
  final Color selectedFontColor = AppTheme.font_color;
  final Color unSelectedFontColor = Color(0x070417).withOpacity(0.4);
  final controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.75,
      height: width * 0.12,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFE9E9FF)),
      child: Row(
        children: [
          toggleButtonItem(ChartContentType.WEEK),
          toggleButtonItem(ChartContentType.MONTH)
        ],
      ),
    );
  }

  Widget toggleButtonItem(ChartContentType type) {
    print("BarChartToggleButton - type = ${controller.selectedChartType}");
    return Flexible(
        flex: 1,
        child: InkWell(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: controller.selectedChartType == type
                    ? selectedColor
                    : unSelectedColor),
            child: Center(
              child: Text(
                controller.toChartTypeString(type),
                style: GoogleFonts.ptSans(
                    fontSize: fontSize,
                    color: controller.selectedChartType == type
                        ? selectedFontColor
                        : unSelectedFontColor,
                    fontWeight: fontWeight),
              ),
            ),
          ),
          onTap: () => type == ChartContentType.WEEK
              ? controller.loadWeekTimeData(DateTime.now())
              : controller.loadMonthTimeData(DateTime.now()),
        ));
  }
}
