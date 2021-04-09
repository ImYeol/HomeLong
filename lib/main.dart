import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/repository/%20authRepository.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/counterService.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/splashPage.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';
import 'home/homePage.dart';
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
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  final routes = {
    '/Login': (BuildContext context) => LoginPage(),
    '/Main': (BuildContext context) => MainApp(),
    '/Wifi': (BuildContext context) => WifiSettingPage()
  };

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()
          ),
          RepositoryProvider<WifiConnectionService>(
            create: (context) => WifiConnectionService()
          ),
          RepositoryProvider<CounterService>(
            create: (context) => CounterService()..init()
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            // font : google popsins font
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            primarySwatch: AppTheme.primarySwatch,
            primaryColor: AppTheme.primaryColor, // primary color
            accentColor: AppTheme.accentColor,
            backgroundColor: AppTheme.backgroundColor, // background color
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomAppBarColor: AppTheme.bottomAppBarColor,
            textSelectionColor: AppTheme.primaryColor,
            focusColor: AppTheme.focusColor,
            disabledColor: AppTheme.disabledColor,
          ),
          initialRoute: '/Main',
          routes: routes,
          navigatorKey: _navigatorKey,

          //The SplashPage is shown while the application determines the authentication state of the user
          onGenerateRoute: (_) => SplashPage.route(),
        ));
  }
}
