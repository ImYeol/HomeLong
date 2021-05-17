import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/home/homePage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/rank/bloc/rankCubit.dart';
import 'package:homg_long/rank/rank.dart';
import 'package:homg_long/screen/bloc/appScreenCubit.dart';
import 'package:homg_long/screen/model/appScreenState.dart';

class AppScreen extends StatefulWidget {
  AppScreen({Key key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with WidgetsBindingObserver {
  LogUtil logUtil = LogUtil();
  final AppScreenCubit cubit = AppScreenCubit();

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance?.addObserver(this);
    cubit.init();
    logUtil.logger.d("initstate app");
  }

  @override
  void dispose() {
    super.dispose();
    cubit.dispose();
    logUtil.logger.d("dispose app");
    //WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logUtil.logger.d("didChangeDependencies app");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    logUtil.logger.d("didchangeApplifeCycleState : $state");

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      logUtil.logger.d("background app");
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
          appBar:
              AppBar(title: const Text('Geofence Service'), centerTitle: true),
          body: BlocProvider<AppScreenCubit>.value(
              value: cubit, child: _buildMainContents(context)),
        ));
  }

  Widget _buildMainContents(BuildContext context) {
    return BlocConsumer<AppScreenCubit, AppScreenState>(
      listenWhen: (previous, current) =>
          (previous is! PageLoading) && (previous != current),
      listener: (context, state) {
        if (state == HomePage) {
          logUtil.logger.d("state is homePage");
        }
      },
      builder: (context, state) => Scaffold(
        body: state.widget,
        bottomNavigationBar: _buildOriginDesign(context),
      ),
    );
  }

  Widget _buildOriginDesign(BuildContext context) {
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
      currentIndex: cubit.currentPage,
      onTap: (index) => cubit.dispatch(index),
    );
  }
}
