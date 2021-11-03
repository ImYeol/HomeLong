import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/chart/barChartContent.dart';
import 'package:homg_long/chart/bloc/chartPageCubit.dart';
import 'package:homg_long/chart/chartContainer.dart';
import 'package:homg_long/chart/chartSubTitle.dart';
import 'package:homg_long/chart/dateTimeConverter.dart';
import 'package:homg_long/chart/models/chartPageState.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/utils/circularProgressIndicatorWrapper.dart';
import 'package:logging/logging.dart';

class ChartPage extends StatefulWidget {
  ChartPageCubit cubit;
  ChartPage({Key key, this.cubit}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with WidgetsBindingObserver {
  final log = Logger("ChartPage");
  static const double contentPadding = 20.0;

  Color backgroundColor = Colors.grey[150];
  Color subTitleColor = Colors.brown[300];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //widget.cubit.loadPage();
    log.info('initState');
  }

  @override
  void dispose() {
    log.info('dispose');
    WidgetsBinding.instance.removeObserver(this);
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
    log.info("ChartPage build");
    widget.cubit.loadPage();
    return BlocBuilder<ChartPageCubit, ChartPageState>(
        cubit: widget.cubit,
        builder: (context, state) {
          if (state is ChartPageLoading) {
            return CircularProgressIndicatorWrapper();
          } else {
            return buildView(context, state);
          }
        });
  }

  Widget buildView(BuildContext context, ChartPageState state) {
    return Container(
      color: backgroundColor,
      child: ListView(
        children: <Widget>[
          ChartSubTitle(
              title: "Time to stay at home",
              fontColor: subTitleColor,
              fontSize: 20),
          const SizedBox(
            height: 8,
          ),
          toggleButtonMenu(),
          const SizedBox(
            height: 8,
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              child: (state is ChartPageLoaded)
                  ? ChartContainer(
                      title: state.chartInfo.title,
                      color: Colors.white,
                      chart: BarChartContent(
                        chartInfo: state.chartInfo,
                      ),
                    )
                  : Container()),
        ],
      ),
    );
  }

  Widget toggleButtonMenu() {
    return Center(
        child: ToggleButtons(
      color: Colors.black.withOpacity(0.60),
      selectedColor: Colors.green,
      selectedBorderColor: Color(0xFF6200EE),
      fillColor: Color(0xFF6200EE).withOpacity(0.08),
      splashColor: Color(0xFF6200EE).withOpacity(0.12),
      hoverColor: Color(0xFF6200EE).withOpacity(0.04),
      borderRadius: BorderRadius.circular(5.0),
      constraints: BoxConstraints(minHeight: 35.0, minWidth: 150),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('Week'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('Month'),
        ),
      ],
      isSelected: widget.cubit.isSelected,
      onPressed: (index) {
        widget.cubit.requestChartUpdated(index);
      },
    ));
  }
}
