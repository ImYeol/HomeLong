import 'package:homg_long/repository/db.dart';

class InAppUser {
  String id;
  String image;
  String ssid;
  String bssid;
  String week;
  String timeInfo;

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
  }

  Map<String, dynamic> getUser() {
    return {
      "id": this.id,
      "image": this.image,
      "ssid": this.ssid,
      "bssid": this.bssid,
      "timeInfo": this.timeInfo,
    };
  }
}
