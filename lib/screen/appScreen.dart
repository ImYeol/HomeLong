import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/feed/feedPage.dart';
import 'package:homg_long/friends/friendsPage.dart';
import 'package:homg_long/home/counterPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/screen/bloc/fcmHelper.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/setting/setting.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScreen extends StatefulWidget {
  AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  LogUtil logUtil = LogUtil();
  int _selectedIndex = 0;
  final log = Logger("AppScreen");

  @override
  void initState() {
    super.initState();
    log.info("initialize app");
    handleFcmMessages();
  }

  @override
  void dispose() {
    super.dispose();
    log.info("dispose app");
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
          return UserActionManager().needForegroundTask();
        },
        androidNotificationOptions: AndroidNotificationOptions(
            channelId: 'geofence_service_notification_channel',
            channelName: 'Geofence Service Notification',
            channelDescription:
                'This notification appears when the geofence service is running in the background.',
            channelImportance: NotificationChannelImportance.LOW,
            priority: NotificationPriority.LOW),
        notificationTitle: 'Geofence Service is running',
        notificationText: 'Tap to return to the app',
        child: Scaffold(
          // set SafeArea for top padding
          body: SafeArea(child: tabPages(_selectedIndex)),
          bottomNavigationBar: buildBottomNavigationBar(),
        ));
  }

  Widget tabPages(int index) {
    switch (index) {
      case 0:
        return CounterPage();
      case 1:
        return FriendPage();
      case 2:
        return FeedPage();
      case 3:
        return SettingPage();
      default:
        return Container();
    }
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.icon_selected_color,
        unselectedItemColor: AppTheme.icon_unselected_color,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "timer",
            icon: Icon(Icons.timer),
          ),
          BottomNavigationBarItem(
            label: "friends",
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
              label: "knock",
              icon: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  "images/fist.png",
                  color: AppTheme.icon_unselected_color,
                ),
              ),
              activeIcon: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  "images/fist.png",
                  color: AppTheme.icon_selected_color,
                ),
              )),
          BottomNavigationBarItem(
            label: "settings",
            icon: Icon(Icons.settings),
          ),
        ]);
  }
}
