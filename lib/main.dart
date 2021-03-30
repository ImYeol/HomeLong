import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/setting/setting.dart';
import 'home/home.dart';
import 'rank/rankPage.dart';
import 'simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(HomeStarted()),
        ),
      ],
      child: MaterialApp(
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
        initialRoute: '/', // initial page => set login page
        routes: {
          '/': (context) => MyAppView(),
        },
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
  int _currentIndex = 0;

  List<Widget> pages = <Widget>[HomePage(), RankPage(), SettingPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: pages[_currentIndex],
        bottomNavigationBar: _buildOriginDesign());
  }

  Widget _buildOriginDesign() {
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
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
