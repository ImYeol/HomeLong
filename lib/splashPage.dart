import 'package:flutter/material.dart';
import 'package:homg_long/const/appTheme.dart';
import 'package:homg_long/utils/ui.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("main : $width : $height");
    return Container(
        child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Center(child: headerTextBox(AppTheme.appName))));
  }
}
