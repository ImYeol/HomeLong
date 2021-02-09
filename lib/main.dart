import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/Timer/bloc/timer_bloc.dart';
import 'package:homg_long/authentication/authentication.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/setting/setting.dart';
import 'package:homg_long/splashPage.dart';

import 'Timer/timer.dart';
import 'home/home.dart';
import 'login/loginPage.dart';
import 'rank/rankPage.dart';
import 'simple_bloc_observer.dart';

//https://fkkmemi.github.io/ff/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AuthenticationRepository authenticationRepository;

  const MyApp({Key key, @required this.authenticationRepository});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: MyAppView(),
      ),
    );
  }
}

class MyAppView extends StatefulWidget {
  MyAppView({Key key}) : super(key: key);

  @override
  _MyAppViewState createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // font : google popsins font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
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
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  MainApp.route(state.user),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      //The SplashPage is shown while the application determines the authentication state of the user
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
