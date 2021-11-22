import 'package:flutter/material.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/utils/ui.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Center(child: headerTextBox(AppTheme.appName))));
  }
}
