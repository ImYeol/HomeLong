import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/repository/gpsService.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/screen/appScreen.dart';
import 'package:homg_long/splashPage.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';
import 'package:logging/logging.dart' as logging;

import 'gps/view/gpsSettingPage.dart';
import 'login/view/loginPage.dart';
import 'simple_bloc_observer.dart';

//https://fkkmemi.github.io/ff/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;

  // initalize custom bloc observer to print log.
  Bloc.observer = SimpleBlocObserver();

  // run myapp with auth repository.
  runApp(MyApp());

  LogUtil logUtil = LogUtil();
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  LogUtil logUtil = LogUtil();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final log = logging.Logger("Main");

  NavigatorState get _navigator => _navigatorKey.currentState;

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
          RepositoryProvider<WifiConnectionService>(
              create: (context) => WifiConnectionService.instance),
          RepositoryProvider<GPSService>(create: (context) => GPSService()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            // font : google popsins font
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            primarySwatch: AppTheme.primarySwatch,
            primaryColor: AppTheme.primaryColor,
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
          initialRoute: '/Login',
          routes: routes,
          navigatorKey: _navigatorKey,

          //The SplashPage is shown while the application determines the authentication state of the user
          onGenerateRoute: (_) => SplashPage.route(),
        ));
  }
}
