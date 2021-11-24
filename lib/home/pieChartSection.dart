import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width / 1.5;
    _height = MediaQuery.of(context).size.width / 2;

    return Container(
        width: _width,
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [countTimeText(), pieChart(), indicators()],
        ));
  }

  Widget countTimeText() {
    return Text(
      "15:30",
      style: GoogleFonts.quicksand(
          color: Color(0xff707070), fontSize: 40, fontWeight: FontWeight.bold),
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
            value: 0.2, //tick.atHomeTime / CounterCubit.TOTAL_MINUTE_A_DAY,
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
            value: 0.8, //tick.outHomeTime / CounterCubit.TOTAL_MINUTE_A_DAY,
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
