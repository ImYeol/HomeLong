class URL {
  static String serverHost = "http://61.98.89.97";
  static String serverPort = ":8083";

  // for test
  // static String serverPort = ":8084";

  // login
  static Uri setUserInfoURL =
      Uri.parse(serverHost + serverPort + "/account/set");
  static Uri getUserInfoURL =
      Uri.parse(serverHost + serverPort + "/account/get");

  // info
  static Uri setLocationURL =
      Uri.parse(serverHost + serverPort + "/location/set");
  static Uri setWifiURL = Uri.parse(serverHost + serverPort + "/wifi/set");

  // time
  static Uri getDayTimeURL =
      Uri.parse(serverHost + serverPort + "/time/day/get");
  static Uri getWeekTimeRUL =
      Uri.parse(serverHost + serverPort + "/time/week/get");
  static Uri getMonthTimeRUL =
      Uri.parse(serverHost + serverPort + "/time/month/get");

  static Uri setDayTimeURL =
      Uri.parse(serverHost + serverPort + "/time/day/set");
}
