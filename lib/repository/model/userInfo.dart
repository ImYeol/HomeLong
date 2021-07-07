class UserInfo {
  String id;
  String name;
  String image;
  String ssid;
  String bssid;
  String street;
  double latitude = double.infinity; // as initial value
  double longitude = double.infinity; // as initial value

  fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    ssid = json['ssid'];
    bssid = json['bssid'];
    street = json['street'];
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
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }
}
