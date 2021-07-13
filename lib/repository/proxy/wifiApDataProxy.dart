import 'package:http/http.dart' as http;

class WifiApDataProxy {
  static final String post_wifi_ap_url = 'http://testserver/register/user/ap';
  static final String fetch_wifi_ap_url = 'http://testserver/register/user/ap';

  static Future<bool> uploadWifiAPInfo(
      String id, String ssid, String bssid) async {
    http.Response response = await http.post(
      Uri.parse(post_wifi_ap_url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: <String, String>{'id': id, 'ssid': ssid, 'bssid': bssid},
    );
    return (response.statusCode == 200);
  }
}
