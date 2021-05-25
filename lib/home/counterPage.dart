import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterPage extends StatefulWidget {
  CounterPage({Key key}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int touchedIndex = -1;
  Color backgroundColor = Colors.grey[150];
  Color subTitleColor = Colors.purpleAccent;

  @override
  Widget build(BuildContext context) {
    print("counterPage build");
    return Expanded(
        child: Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSubTitle("Homebody Level", subTitleColor),
          Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Card(
                color: Colors.white,
                child: buildChart(),
              )),
          SizedBox(
            height: 10,
          ),
          Center(
            child: buildInAndOutWidget("In", 16),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: buildInAndOutWidget("Out", 8),
          )
        ],
      ),
    ));
  }

  Widget buildInAndOutWidget(String title, int time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitle(title + " : ", 50, Colors.green[500]),
        SizedBox(
          height: 20,
        ),
        buildTitle(time.toString(), 50, Colors.purple[800]),
      ],
    );
  }

  Widget buildTitle(String title, double size, Color color) {
    return Text(
      title,
      style: GoogleFonts.bebasNeue(color: color, fontSize: size),
    );
  }

  Widget buildSubTitle(String title, Color color) {
    double subTitleSize = 20;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: buildTitle(title, subTitleSize, color),
      ),
    );
  }

  Widget buildChart() {
    return AspectRatio(
        aspectRatio: 1.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "24 / 3",
              style:
                  GoogleFonts.bebasNeue(color: Colors.green[500], fontSize: 50),
            ),
            PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      final desiredTouch =
                          pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                      if (desiredTouch &&
                          pieTouchResponse.touchedSection != null) {
                        touchedIndex = pieTouchResponse
                            .touchedSection?.touchedSectionIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                  sections: showingSections()),
            ),
          ],
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 50.0 : 30.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 70,
            title: '70%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
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
