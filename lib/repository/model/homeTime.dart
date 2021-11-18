import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';

part 'homeTime.g.dart';

@HiveType(typeId: HiveTypeId.HIVE_HOME_TIME_ID)
class HomeTime {
  static const int INIT_TIME_OF_A_DAY = 0;
  static const int LAST_TIME_OF_A_DAY = 240000;

  @HiveField(0)
  final String enterTime; // ex) 2014-02-15 08:57:47.812
  @HiveField(1)
  final String exitTime; // ex) 2014-02-15 08:57:47.812
  @HiveField(2)
  final String description;

  HomeTime(
      {required this.enterTime,
      required this.exitTime,
      required this.description});

  HomeTime.fromJson(Map<String, dynamic> json)
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
