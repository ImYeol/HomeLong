import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/home/model/homeState.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/rank/rank.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/setting/setting.dart';

class MainApp extends StatefulWidget {
  final UserInfo userInfo;
  const MainApp({Key key, this.userInfo}) : super(key: key);

  static Route route(UserInfo userInfo) {
    return MaterialPageRoute<void>(
        builder: (_) => MainApp(
              userInfo: userInfo,
            ));
  }

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  List<Widget> pages = <Widget>[HomePage(), RankPage(), SettingPage()];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (BuildContext context) => HomeCubit(
              context.read<WifiConnectionService>(),
            ),
          ),
          BlocProvider<RankBloc>(
            create: (BuildContext context) => RankBloc(),
          ),
          BlocProvider<SettingBloc>(
            create: (BuildContext context) => SettingBloc(),
          ),
        ],
        child: Scaffold(
            body: pages[_currentIndex],
            bottomNavigationBar: _buildOriginDesign()));
  }

  Widget _buildOriginDesign() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Theme.of(context).focusColor,
      strokeColor: Colors.white,
      unSelectedColor: Theme.of(context).disabledColor,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      bubbleCurve: Curves.linear,
      opacity: 1.0,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          selectedTitle: Text("Home"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.people),
          selectedTitle: Text("Rank"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.settings),
          selectedTitle: Text("Setting"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // context.read<HomeCubit>().init();
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
                  timerType: "day",
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
              AverageTimeDisplay()
            ],
          ),
        ));
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
  final String timerType;
  final TextStyle textStyle;

  const TimerTextDisplay({this.timerType, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previousState, currentState) {
      return currentState is DataLoaded;
    }, builder: (context, event) {
      return Center(
          child: Text(
        getTimerValue(event),
        style: textStyle,
      ));
    });
  }

  String getTimerValue(HomeState event) {
    if (timerType == "day")
      return event.day.toString();
    else if (timerType == "week")
      return event.week.toString();
    else if (timerType == "month") return event.month.toString();
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
  const AverageTimeDisplay({Key key}) : super(key: key);

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
                  timerType: "week",
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
                  timerType: "month",
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
