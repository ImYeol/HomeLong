class UserInfo {
  String id;
  String name;
  String image;
  String ssid;
  String bssid;
  String street;
  int initDate;
  double latitude = double.infinity; // as initial value
  double longitude = double.infinity; // as initial value

  UserInfo(
      {String id = "",
      String name = "",
      String image = "",
      String ssid = "",
      String bssid = "",
      String street = "",
      int initDate = 0,
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
    initDate = int.parse(json['initDate']);
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
}
