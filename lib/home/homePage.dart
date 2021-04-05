import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/home.dart';
import 'package:homg_long/rank/rank.dart';
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
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc()..add(HomeStarted()),
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
        body: BlocBuilder<WifiSettingCubit, WifiConnectionInfo>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TitleWidget(
                    title: (state is WifiNotconnected)
                        ? "Not Staying At Home"
                        : "Staying At Home For",
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TimerDisplay(hour: state.curHour, minute: state.curMinute),
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
            );
          },
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

class TimerDisplay extends StatelessWidget {
  final int hour;
  final int minute;
  const TimerDisplay({Key key, this.hour, this.minute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        minute.toString() + " : " + hour.toString(),
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_big,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DateDisplay extends StatelessWidget {
  const DateDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Monday 25 Jan 2021",
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
              getTimeView(3),
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
              getTimeView(30)
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

  Widget getTimeView(double time) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              time.toString(),
              style: TextStyle(
                  fontSize: AppTheme.subtitle_font_size_big,
                  color: AppTheme.reverse_font_color,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Hour",
              style: TextStyle(
                  fontSize: AppTheme.subtitle_font_size_small,
                  color: AppTheme.reverse_font_color,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ]),
    );
  }
}
