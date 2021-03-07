import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/login/login.dart';
import 'package:homg_long/repository/%20authRepository.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/splashPage.dart';
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
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class MyApp extends StatelessWidget {
  // repository which can access user info.
  final AuthenticationRepository authenticationRepository;

  const MyApp({Key key, @required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    // repository provider can access value by context.
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MyAppView(),
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

  final routes = {
    '/Login': (BuildContext context) => LoginPage(),
    '/Main': (BuildContext context) => MainApp(),
  };

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
      initialRoute: '/Login',
      routes: routes,
      navigatorKey: _navigatorKey,

      //The SplashPage is shown while the application determines the authentication state of the user
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
