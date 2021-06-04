import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/proxy/model/timeData.dart';

class HomePage extends StatelessWidget {
  final logUtil = LogUtil();

  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: TimeData(),
        stream: context.watch<HomeCubit>().counterStream,
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.share,
                        color: AppTheme.icon_color, size: AppTheme.icon_size),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TitleWidget(
                      title: "Staying At Home For",
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TimerTextDisplay(
                        timeString: snapshot.data.toDayString(),
                        textStyle: TextStyle(
                            fontSize: AppTheme.subtitle_font_size_big,
                            color: AppTheme.font_color,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    DateDisplay(),
                    SizedBox(
                      height: 20,
                    ),
                    DetailsSubTitle(),
                    SizedBox(
                      height: 20,
                    ),
                    AverageTimeDisplay(
                        weekTimeString: snapshot.data.toWeekString(),
                        monthTimeString: snapshot.data.toMonthString())
                  ],
                ),
              ));
        });
  }
}

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppTheme.header_font_size,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class TimerTextDisplay extends StatelessWidget {
  final String timeString;
  final TextStyle textStyle;

  const TimerTextDisplay({this.timeString, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      timeString,
      style: textStyle,
    ));
  }
}

class DateDisplay extends StatelessWidget {
  const DateDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var y2k = DateTime(now.year, now.month, now.day);
    return Center(
      child: Text(
        y2k.month.toString() +
            " " +
            y2k.day.toString() +
            ", " +
            y2k.year.toString(),
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_middle,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DetailsSubTitle extends StatelessWidget {
  const DetailsSubTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Details",
            style: TextStyle(
                fontSize: AppTheme.subtitle_font_size_small,
                color: AppTheme.font_color,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color: AppTheme.icon_color, size: AppTheme.icon_size),
            onPressed: () {},
          ),
        ]);
  }
}

class AverageTimeDisplay extends StatelessWidget {
  final String weekTimeString;
  final String monthTimeString;

  const AverageTimeDisplay({this.weekTimeString, this.monthTimeString});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTitle("Week"),
              SizedBox(
                height: 10,
              ),
              TimerTextDisplay(
                  timeString: weekTimeString,
                  textStyle: TextStyle(
                      fontSize: AppTheme.subtitle_font_size_small,
                      color: AppTheme.font_color,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTitle("Month"),
              SizedBox(
                height: 10,
              ),
              TimerTextDisplay(
                  timeString: monthTimeString,
                  textStyle: TextStyle(
                      fontSize: AppTheme.subtitle_font_size_small,
                      color: AppTheme.font_color,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }

  Widget getTitle(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_middle,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
