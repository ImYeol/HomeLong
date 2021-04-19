import 'dart:convert';

import 'package:homg_long/proxy/model/apInfo.dart';
import 'package:http/http.dart' as http;

class WifiApDataProxy {
  static final String post_wifi_ap_url = 'http://testserver/register/user/ap';
  static final String fetch_wifi_ap_url = 'http://testserver/register/user/ap';

  static Future<bool> uploadWifiAPInfo(
      String id, String ssid, String bssid) async {
    http.Response response = await http.post(
      post_wifi_ap_url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: <String, String>{'id': id, 'ssid': ssid, 'bssid': bssid},
    );
    return (response.statusCode == 200);
  }

  static Future<APInfo> fetchApInfo(String id) async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      return APInfo.fromJson(json.decode(response.body));
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }
}
