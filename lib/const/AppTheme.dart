import 'package:flutter/material.dart';

class AppTheme {
  static String appName = "HomeLong";

  static double icon_size = 35.0;
  static Color icon_color = Colors.white;
  static Color bottomAppBarColor = Colors.white;
  static Color bottom_menu_icon_color = Color(0xff2c3e50);
  static Color backgroundColor = Color(0xff2c3e50);
  static Color primaryColor = Colors.white;
  static MaterialColor primarySwatch = MaterialColor(
    0xFFFFFFFF, // primary color
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static Color accentColor = Colors.deepPurple.shade900;
  static Color focusColor = Color(0xff2c3e50);
  static Color disabledColor = Colors.grey;

  // about font
  static Color font_color = Colors.white;
  static Color reverse_font_color = Colors.black;
  static double header_font_size = 35.0;
  static double subtitle_font_size_small = 15.0;
  static double subtitle_font_size_middle = 20.0;
  static double subtitle_font_size_big = 40.0;

  // button
  static Color alertButtonTextColor = Colors.white;
  static Color alertButtonBackgroundColor = Colors.blueAccent;

  //
  static const double cardViewRadius = 30;
}
