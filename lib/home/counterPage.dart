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
  Color subTitleColor = Colors.brown[300];

  @override
  Widget build(BuildContext context) {
    print("counterPage build");
    return Expanded(
        child: Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSubTitle("Today In & Out", subTitleColor),
          Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                color: Colors.white,
                child: buildChart(),
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildInAndOutWidget("In", "15:42"),
              buildInAndOutWidget("Out", "8:18"),
            ],
          )
        ],
      ),
    ));
  }

  Widget buildInAndOutWidget(String title, String time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitle(title, 30, Colors.brown[500]),
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Container(
              width: 150,
              height: 70,
              child: Center(child: buildTitle(time, 30, Colors.purple[800]))),
        )
      ],
    );
  }

  Widget buildTitle(String title, double size, Color color) {
    return Text(title,
        style: GoogleFonts.firaSans(
            color: color, fontSize: size, fontWeight: FontWeight.bold));
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
              "70%",
              style:
                  GoogleFonts.bebasNeue(color: Colors.brown[400], fontSize: 50),
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
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Indicator(
                            color: Colors.brown[500],
                            isSquare: true,
                            size: 16,
                            text: "In",
                            textColor: Colors.brown[500],
                          ),
                          Indicator(
                            color: Colors.cyan[500],
                            isSquare: true,
                            size: 16,
                            text: "out",
                            textColor: Colors.brown[500],
                          )
                        ])))
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
            showTitle: false,
            color: Colors.brown[400],
            //const Color(0xff0293ee),
            value: 70,
            title: null,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: Colors.cyan[500],
            //const Color(0xfff8b250),
            value: 30,
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
      {Key key,
      this.color,
      this.text,
      this.isSquare,
      this.size = 16,
      this.textColor})
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
