class URL {
  static String serverHost = "http://192.168.0.14";
  static String serverPort = ":8080";

  // for test
  // static String serverPort = ":8084";

  // login
  static Uri setUserInfoURL =
      Uri.parse(serverHost + serverPort + "/account/set");
  static Uri getUserInfoURL =
      Uri.parse(serverHost + serverPort + "/account/get");

  static final String post_wifi_ap_url = 'http://testserver/register/user/ap';
  static final String fetch_wifi_ap_url = 'http://testserver/register/user/ap';

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

  // friend
  static Uri setFriendURL = Uri.parse(serverHost + serverPort + "/friend/set");
  static Uri getAllFriendURL =
      Uri.parse(serverHost + serverPort + "/friend/get/all");
  static Uri getFriendURL = Uri.parse(serverHost + serverPort + "/friend/get");
  static Uri deleteFriendURL =
      Uri.parse(serverHost + serverPort + "/friend/delete");
}
