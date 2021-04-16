import 'package:http/http.dart' as http;

class URL{
  static String serverHost = "http://192.168.35.235";
  static String serverPort = ":8080";

  // login
  static String kakaoLoginURL = serverHost+serverPort+ "/login/kakao";
  static String facebookLoginURL = serverHost+serverPort+"/login/facebook";

  // time
  static String getDayTimeURL = serverHost+serverPort+"/time/day/get";
  static String getWeekTimeRUL = serverHost+serverPort+"/time/week/get";
  static String getMonthTimeRUL = serverHost+serverPort+ "/time/month/get";

  static String setDayTimeURL = serverHost+serverPort+"/time/day/set";

  // friend

}