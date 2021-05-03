import 'package:homg_long/repository/db.dart';

class InAppUser {
  String id;
  String image;
  String ssid;
  String bssid;
  String week;
  String timeInfo;
  double latitude;
  double longitude;

  InAppUser._();
  static final InAppUser _user = new InAppUser._();

  // factory constructor.
  factory InAppUser() {
    return _user;
  }

  setUser(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    ssid = json['ssid'];
    bssid = json['bssid'];
    timeInfo = json['timeInfo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> getUser() {
    return {
      "id": this.id,
      "image": this.image,
      "ssid": this.ssid,
      "bssid": this.bssid,
      "timeInfo": this.timeInfo,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }
}
