import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';

import 'home/home.dart';
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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => homePage(),
        },
      ),
    );
  }
}
