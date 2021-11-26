import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/home/bloc/counterController.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:intl/intl.dart';

class PieChartSection extends StatefulWidget {
  PieChartSection({Key? key}) : super(key: key);

  @override
  _PieChartSectionState createState() => _PieChartSectionState();
}

class _PieChartSectionState extends State<PieChartSection> {
  final Color IN_COLOR = Color(0xFFF68D5F);
  final Color OUT_COLOR = Colors.cyan;
  int _touchedIndex = -1;
  late double _width;
  late double _height;
  NumberFormat formatter = NumberFormat("00");
  var controller = Get.find<CounterController>();

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width / 1.5;
    _height = MediaQuery.of(context).size.width / 2;

    return Container(
        width: _width,
        height: _height,
        child: Obx(() {
          return Stack(
            alignment: Alignment.center,
            children: [countTimeText(), pieChart(), indicators()],
          );
        }));
  }

  Widget countTimeText() {
    final hour = controller.accumulatedHomeTime.value / 3600;
    final minute = controller.accumulatedHomeTime / 60;
    final second = controller.accumulatedHomeTime % 60;
    return Text(
      "${formatter.format(hour.toInt())}:${formatter.format(minute.toInt())}:${formatter.format(second.toInt())}",
      style: GoogleFonts.quicksand(
          color: Color(0xff707070), fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget pieChart() {
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              final desiredTouch =
                  pieTouchResponse.touchInput is! PointerExitEvent &&
                      pieTouchResponse.touchInput is! PointerUpEvent;
              if (desiredTouch && pieTouchResponse.touchedSection != null) {
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              } else {
                _touchedIndex = -1;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          startDegreeOffset: 270,
          sectionsSpace: 0,
          centerSpaceRadius: _height / 3,
          sections: showingSections()),
    );
  }

  Widget indicators() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Indicator(
                    color: IN_COLOR,
                    isSquare: true,
                    size: 16,
                    text: "In",
                    textColor: Colors.brown.shade500,
                  ),
                  Indicator(
                    color: OUT_COLOR,
                    isSquare: true,
                    size: 16,
                    text: "out",
                    textColor: Colors.brown.shade500,
                  )
                ])));
  }

  List<PieChartSectionData> showingSections() {
    final in_time_percent =
        controller.accumulatedHomeTime.value / HomeTime.TOTAL_SECOND_A_DAY;
    final out_time_percent = 1 - in_time_percent;

    return List.generate(2, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 20.0 : 10.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: Color(0xFFF68D5F),
            //const Color(0xff0293ee),
            value:
                in_time_percent, //tick.atHomeTime / CounterCubit.TOTAL_MINUTE_A_DAY,
            title: null,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.cyan[500],
            //const Color(0xfff8b250),
            value:
                out_time_percent, //tick.outHomeTime / CounterCubit.TOTAL_MINUTE_A_DAY,
            title: null,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator(
      {Key? key,
      required this.color,
      required this.text,
      required this.isSquare,
      this.size = 16,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
