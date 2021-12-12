import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/cubit/loginController.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/screen/appScreen.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:homg_long/utils/router.dart';
import 'package:logging/logging.dart' as logging;

import 'login/view/loginPage.dart';

//https://fkkmemi.github.io/ff/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;

  // initalize custom bloc observer to print log.
  //Bloc.observer = SimpleBlocObserver();
  print("main started");
  // initialize hive
  await Hive.initFlutter();
  await Firebase.initializeApp();
  UserRepository().init();
  TimeRepository().init();
  await UserRepository().openDatabase();
  await TimeRepository().openDatabase();
  UserActionManager().init();
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
  final loginController = Get.put(LoginController());

  NavigatorState? get _navigator => _navigatorKey.currentState;

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
    //Hive.close();
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
    return GetMaterialApp(
        theme: ThemeData(
          // font : google popsins font
          textTheme:
              GoogleFonts.pontanoSansTextTheme(Theme.of(context).textTheme),
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
        defaultTransition: Transition.rightToLeftWithFade,
        getPages: GetXRouter.route,
        navigatorKey: _navigatorKey,
        home: auth.FirebaseAuth.instance.currentUser == null
            ? LoginPage()
            : AppScreen());
  }
}
