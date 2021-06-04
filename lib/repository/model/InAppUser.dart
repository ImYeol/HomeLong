class InAppUser {
  String id;
  String name;
  String image;
  String ssid;
  String bssid;
  String week;
  String timeInfo;
  String street;
  double latitude = double.infinity; // as initial value
  double longitude = double.infinity; // as initial value

  InAppUser._();

  static final InAppUser _user = new InAppUser._();

  // factory constructor.
  factory InAppUser(
      {String id,
      String name,
      String image,
      String ssid,
      String bssid,
      String week,
      String timeInfo,
      String street,
      double latitude,
      double longitude}) {
    return _user;
  }

  setUser(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    ssid = json['ssid'];
    bssid = json['bssid'];
    week = json['week'];
    timeInfo = json['timeInfo'];
    street = json['street'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> getUser() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
      "ssid": this.ssid,
      "bssid": this.bssid,
      "week": this.week,
      "timeInfo": this.timeInfo,
      "street": this.street,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }

  @override
  String toString() {
    return "";
    // TODO: implement toString
    // return "id:" +
    //     this.id +
    //     ", image:" +
    //     this.image +
    //     ", ssid:" +
    //     this.ssid +
    //     ", bssid:" +
    //     this.bssid;
    // ", latitude:" +
    // this.latitude?.toString() +
    // ", longitude:" +
    // this.longitude?.toString();
  }
}
