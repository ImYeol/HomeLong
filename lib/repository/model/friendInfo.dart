import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';
import 'package:homg_long/repository/model/userInfo.dart';

part 'friendInfo.g.dart';

@HiveType(typeId: HiveTypeId.HIVE_FRIEND_INFO_ID)
class FriendInfo {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String image;
  @HiveField(3)
  late bool atHome;

  FriendInfo(
      {String id = "",
      String name = "",
      String image = "",
      bool isAtHome = false}) {
    this.id = id;
    this.name = name;
    this.image = image;
    this.atHome = isAtHome;
  }

  FriendInfo.invalidFriend() {
    id = InvalidUserInfo.INVALID_ID;
  }

  FriendInfo.fromJson(Map<String, dynamic> json) {
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
      "atHome": this.atHome
    };
  }
}
