//https://github.com/bkonyi/FlutterGeofencing

import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:homg_long/log/logger.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundFetcher {
  final EVENTS_KEY = "fetch_events";
  final LogUtil logUtil = LogUtil();
  final log = Logger("BackgroundFetcher");

  static final BackgroundFetcher instance = BackgroundFetcher._();

  List<String> _events = [];
  int _status = 0;
  bool mounted = false;

  BackgroundFetcher._();

  factory BackgroundFetcher() {
    return instance;
  }

  /// This "Headless Task" is run when app is terminated.
  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool timeout = task.timeout;
    if (timeout) {
      logUtil.logger.e("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }

    log.info("[BackgroundFetch] Headless event received: $taskId");
    DateTime timestamp = DateTime.now();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read fetch_events from SharedPreferences
    List<String> events = [];
    String json = prefs.getString(EVENTS_KEY);
    if (json != null) {
      events = jsonDecode(json).cast<String>();
    }
    // Add new event.
    events.insert(0, "$taskId@$timestamp [Headless]");
    // Persist fetch events in SharedPreferences
    prefs.setString(EVENTS_KEY, jsonEncode(events));

    if (taskId == 'flutter_background_fetch') {
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "back back",
          delay: 5000,
          periodic: false,
          forceAlarmManager: false,
          stopOnTerminate: false,
          enableHeadless: true));
    }
    BackgroundFetch.finish(taskId);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Load persisted fetch events from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(EVENTS_KEY);
    if (json != null) {
      _events = jsonDecode(json).cast<String>();
    }
    // Configure BackgroundFetch.
    try {
      int status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 15,
            forceAlarmManager: false,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE,
          ),
          onBackgroundFetch,
          onBackgroundFetchTimeout);
      log.info('[BackgroundFetch] configure success: $status');

      _status = status;

      // Schedule a "one-shot" custom-task in 10000ms.
      // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
      // where device must be powered (and delay will be throttled by the OS).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "homelong",
          delay: 10000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true));
    } catch (e) {
      print('[BackgroundFetch] configure ERROR: $e');
      _status = e;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void onBackgroundFetch(String taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime timestamp = new DateTime.now();
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received: $taskId");
    _events.insert(0, "$taskId@${timestamp.toString()}");
    // Persist fetch events in SharedPreferences
    prefs.setString(EVENTS_KEY, jsonEncode(_events));

    if (taskId == "flutter_background_fetch") {
      log.info("flutter_background_fetch onBackgroundFetch");
      // Schedule a one-shot task when fetch event received (for testing).
      /*
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 5000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresNetworkConnectivity: true,
          requiresCharging: true
      ));
       */
    } else if (taskId == "homelong") {
      log.info("homelong onBackgroundFetch");
    } else {
      log.info("back back onBackgroundFetch");
    }
    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  /// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
  void onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void enableBackgroundFetcher(bool enabled) {
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  Future<int> getFectherStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    return status;
  }

  void clearEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EVENTS_KEY);
    _events = [];
  }
}
