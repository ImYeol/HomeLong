class Time {
  static const String HOME = "HOME";
  static const int INIT_TIME_OF_A_DAY = 0;
  static const int LAST_TIME_OF_A_DAY = 240000;

  late int enterTime; // ex) 14(h):10(m) = 1410
  late int exitTime; // ex) 24(h):00(m) = 2400
  late String description;

  Time({int enterTime = 0, int exitTime = 0, String description = HOME}) {
    this.enterTime = enterTime;
    this.exitTime = exitTime;
    this.description = description;
  }

  Time.fromJson(Map<String, dynamic> json)
      : enterTime = json['enterTime'],
        exitTime = json['exitTime'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'enterTime': enterTime,
        'exitTime': exitTime,
        'description': description,
      };

  @override
  String toString() {
    return "enterTime: ${enterTime} , exitTime: ${exitTime} + description: ${description}";
  }
}
