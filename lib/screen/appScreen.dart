import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/home/counterPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/chart/chart.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/screen/bloc/appScreenCubit.dart';
import 'package:homg_long/setting/setting.dart';
import 'package:logging/logging.dart';

class AppScreen extends StatefulWidget {
  AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  LogUtil logUtil = LogUtil();
  final log = Logger("AppScreen");

  final AppScreenCubit cubit = AppScreenCubit();

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance?.addObserver(this);
    cubit.init();
    log.info("initialize app");
  }

  @override
  void dispose() {
    super.dispose();
    cubit.dispose();
    log.info("dispose app");
    //WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log.info("didChangeDependencies app");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log.info("didchangeApplifeCycleState : $state");

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      log.info("background app");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillStartForegroundTask(
        onWillStart: () {
          // You can add a foreground task start condition.
          //return cubit.geofenceService.isRunningService;
          return cubit.needForegroundTask();
        },
        notificationOptions: NotificationOptions(
            channelId: 'geofence_service_notification_channel',
            channelName: 'Geofence Service Notification',
            channelDescription:
                'This notification appears when the geofence service is running in the background.',
            channelImportance: NotificationChannelImportance.LOW,
            priority: NotificationPriority.LOW),
        notificationTitle: 'Geofence Service is running',
        notificationText: 'Tap to return to the app',
        child: Scaffold(
          body: _buildTabController(context),
        ));
  }

  Widget _buildTabController(BuildContext context) {
    double appBarheight = MediaQuery.of(context).size.height / 5;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarheight),
            child: AppBar(
              // empty leading
              leading: Container(),
              // show Graient background
              flexibleSpace: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Colors.brown.shade900,
                            Colors.brown.shade200
                          ])),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Align(
                        alignment: Alignment.centerRight,
                        widthFactor: 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("HomeBody",
                                style: GoogleFonts.workSans(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold)),
                            Text("Check your life style",
                                style: GoogleFonts.workSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))
                          ],
                        )),
                  )),
              elevation: 0,
              bottom: TabBar(
                  labelColor: Colors.brown[600],
                  // tab icon color
                  unselectedLabelColor: Colors.white,
                  // unselected tab icon color
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45), // for tab border shape
                          topRight: Radius.circular(45)),
                      color: Colors.white),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.access_time_sharp),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.stacked_bar_chart),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.settings),
                      ),
                    ),
                  ]),
            ),
          ),
          body: buildTabBarViews(),
        ));
  }

  Widget buildTabBarViews() {
    return TabBarView(children: [
      CounterPage(cubit: CounterCubit(cubit)),
      ChartPage(
        cubit: ChartPageCubit(cubit),
      ),
      SettingPage()
    ]);
  }
}
