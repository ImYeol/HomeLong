import 'package:get/get.dart';
import 'package:homg_long/gps/view/gpsSettingPage.dart';
import 'package:homg_long/login/view/loginPage.dart';
import 'package:homg_long/main.dart';
import 'package:homg_long/screen/appScreen.dart';
import 'package:homg_long/splashPage.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';

class GetXRouter {
  static final route = [
    GetPage(name: '/Splash', page: () => SplashPage()),
    GetPage(name: '/Login', page: () => LoginPage()),
    GetPage(name: '/Main', page: () => AppScreen()),
    GetPage(name: '/Wifi', page: () => WifiSettingPage()),
    GetPage(name: '/GPS', page: () => GPSSettingPage()),
  ];
}
