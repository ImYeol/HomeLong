import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/friends/friendsPage.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/friends/friendsPage.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/ConnectivityServiceWrapper.dart';
import 'package:homg_long/repository/authentication.dart';
import 'package:homg_long/repository/gpsService.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/appScreen.dart';
import 'package:homg_long/splashPage.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';
import 'package:logging/logging.dart' as logging;

import 'gps/view/gpsSettingPage.dart';
import 'login/view/loginPage.dart';
import 'simple_bloc_observer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//https://fkkmemi.github.io/ff/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;

  // initalize custom bloc observer to print log.
  Bloc.observer = SimpleBlocObserver();
  print("main started");
  // initialize hive
  await Hive.initFlutter();
  UserRepository().init();
  TimeRepository().init();
  // run myapp with auth repository.
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  LogUtil logUtil = LogUtil();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final log = logging.Logger("Main");

  NavigatorState? get _navigator => _navigatorKey.currentState;

  final routes = {
    '/Login': (BuildContext context) => LoginPage(),
    '/Main': (BuildContext context) => AppScreen(),
    '/Wifi': (BuildContext context) => WifiSettingPage(),
    '/GPS': (BuildContext context) => GPSSettingPage()
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    // logging initialize
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((record) {
      print(
          '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
    });
    log.info("initialize app");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log.info("dispose app");

    WidgetsBinding.instance?.removeObserver(this);
    // Hive close
    Hive.close();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
              create: (context) => AuthenticationRepository()),
          RepositoryProvider<ConnectivityServiceWrapper>(
              create: (context) => ConnectivityServiceWrapper.instance),
          RepositoryProvider<GPSService>(create: (context) => GPSService()),
        ],
        child: FutureBuilder(
          future: Future.wait([
            UserRepository().openDatabase(),
            TimeRepository().openDatabase()
          ]),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                // getUserInfo has not completed yet
                // show splash screen
                return buildMainApp(context, SplashPage());
              default:
                if (snapshot.hasData) {
                  //Box box = snapshot.data as Box;
                  //UserInfo userInfo = box.get(UserDB.USER_INFO, defaultValue: InvalidUserInfo());
                  final isDBOpened = snapshot.data as List<bool>;
                  final allDBOpened =
                      isDBOpened.reduce((value, element) => value && element);

                  if (allDBOpened == false) {
                    log.severe("Not All of DB is opened");
                    break;
                  }
                  return buildMainApp(context, AppScreen());

                  // return UserRepository().isLoginSessionValid()
                  //     ? buildMainApp(context, AppScreen())
                  //     : buildMainApp(context, LoginPage());
                } else if (snapshot.hasError) {
                  log.warning("main app got error while page loading");
                  break;
                }
            }
            return buildMainApp(context, SplashPage());
          },
        ));
  }

  Widget buildMainApp(BuildContext context, Widget initialScreen) {
    return MaterialApp(
      theme: ThemeData(
        // font : google popsins font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: AppTheme.primaryColor,
        //primarySwatch: AppTheme.primarySwatch,
        // primary color
        accentColor: AppTheme.accentColor,
        backgroundColor: AppTheme.backgroundColor,
        // background color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomAppBarColor: AppTheme.bottomAppBarColor,
        textSelectionColor: AppTheme.primaryColor,
        focusColor: AppTheme.focusColor,
        disabledColor: AppTheme.disabledColor,
      ),
      home: initialScreen,
      routes: routes,
      navigatorKey: _navigatorKey,
    );
  }
}
