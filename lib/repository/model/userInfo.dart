import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';

part 'userInfo.g.dart';

@HiveType(typeId: HiveTypeId.HIVE_USER_INFO_ID)
class UserInfo {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String image;
  @HiveField(3)
  late String ssid;
  @HiveField(4)
  late String bssid;
  @HiveField(5)
  late String street;
  @HiveField(6)
  late String initDate;
  @HiveField(7)
  double latitude = double.infinity; // as initial value
  @HiveField(8)
  double longitude = double.infinity; // as initial value

  UserInfo(
      {String id = "",
      String name = "",
      String image = "",
      String ssid = "",
      String bssid = "",
      String street = "",
      String initDate = "9999-99-99 99:99:99.999",
      double latitude = 0.0,
      double longitude = 0.0}) {
    this.id = id;
    this.name = name;
    this.image = image;
    this.ssid = ssid;
    this.bssid = bssid;
    this.street = street;
    this.initDate = initDate;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    ssid = json['ssid'];
    bssid = json['bssid'];
    street = json['street'];
    initDate = json['initDate'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
      "ssid": this.ssid,
      "bssid": this.bssid,
      "street": this.street,
      "initDate": this.initDate,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }

  bool isValid() {
    if (this is InvalidUserInfo) {
      return false;
    }
    return true;
  }
}

class InvalidUserInfo extends UserInfo {
  static final String INVALID_ID = "0";
  InvalidUserInfo() : super(id: INVALID_ID);
}
