import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';

part 'friend.g.dart';

@HiveType(typeId: HiveTypeId.HIVE_FRIEND_INFO_ID)
class Friend {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String image;
  @HiveField(3)
  late bool atHome;

  Friend(
      {String id = "",
      String name = "",
      String image = "",
      bool atHome = false}) {
    this.id = id;
    this.name = name;
    this.image = image;
    this.atHome = atHome;
  }

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    atHome = json['atHome'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
      "atHome": this.atHome,
    };
  }

  bool isValid() {
    if (this is InvalidFriend) {
      return false;
    }
    return true;
  }
}

class InvalidFriend extends Friend {
  static final String INVALID_ID = "0";
  InvalidFriend() : super(id: INVALID_ID);
}
