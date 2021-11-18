import 'package:flutter/material.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/barChartContent.dart';
import 'package:homg_long/home/barChartToggleButton.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/screen/bloc/appScreenCubit.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/utils/titleText.dart';

class BarChartSection extends StatefulWidget {
  BarChartSection({Key? key}) : super(key: key);

  @override
  _BarChartSectionState createState() => _BarChartSectionState();
}

class _BarChartSectionState extends State<BarChartSection> {
  List<bool> isSelected = [true, false];
  double width = 0;
  double height = 0;
  final cubit = CounterCubit(AppScreenCubit());

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //toggleButtonMenu(),
        BarChartToggleButton(),
        Container(height: 10),
        chartTitle(),
        barChart()
      ],
    ));
  }

  Widget chartTitle() {
    return TitleText(
      title: isSelected[0] ? "Weekly" : "Monthly",
      fontSize: 20,
      withDivider: false,
    );
  }

  Widget barChart() {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        width: width,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: BarChartContent(
            chartInfo: cubit.loadWeekTimeData(DateTime.now()),
          ),
        ));
  }
}
