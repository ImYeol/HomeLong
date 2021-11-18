import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/home/barChartSection.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/home/model/counterPageState.dart';
import 'package:homg_long/home/pieChartSection.dart';
import 'package:homg_long/home/timeHistorySection.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class CounterPage extends StatefulWidget {
  CounterCubit cubit;
  CounterPage({Key? key, required this.cubit}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with WidgetsBindingObserver {
  final log = Logger("CounterPage");
  int touchedIndex = -1;
  Color backgroundColor = Colors.grey.shade200;
  Color subTitleColor = Colors.brown.shade300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    //widget.cubit.loadPage();
    log.info('initState');
  }

  @override
  void dispose() {
    log.info('dispose');
    WidgetsBinding.instance?.removeObserver(this);
    widget.cubit.unloadPage();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.info('didChangeAppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      log.info("resumed");
      widget.cubit.loadPage();
    } else if (state == AppLifecycleState.paused) {
      widget.cubit.unloadPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("counterPage build");
    //widget.cubit.loadPage();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: TitleText(
                title: "Today\nHomeTime",
                withDivider: false,
                align: TextAlign.center,
                fontSize: 30,
              ),
            ),
            Center(
              child: PieChartSection(),
            ),
            BarChartSection(),
            TimeHistorySection()
          ],
        ),
      ),
    );
  }
}
