import 'package:flutter/material.dart';
import 'package:homg_long/const/appTheme.dart';

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
          body: Center(
              child: Text(
            "Home long",
            style: TextStyle(
                fontSize: AppTheme.header_font_size,
                color: AppTheme.font_color,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))),
    );
  }
}
