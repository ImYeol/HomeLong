import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';
import 'package:homg_long/repository/model/userInfo.dart';

part 'knockFeed.g.dart';

//flutter packages pub run build_runner build
@HiveType(typeId: HiveTypeId.HIVE_KNOCK_FEED_ID)
class KnockFeed {
  @HiveField(0)
  final String senderId; // ex) id
  @HiveField(1)
  final String receiverId; // ex) id
  @HiveField(2)
  final String sentTime; // ex) 2014-02-15 08:57:47.812

  KnockFeed(
      {required this.senderId,
      required this.receiverId,
      required this.sentTime});

  KnockFeed.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        receiverId = InvalidUserInfo().id,
        sentTime = json['sentTime'];

  // Map<String, dynamic> toJson() => {
  //       'senderId': senderId,
  //       'receiverId': receiverId,
  //       'sentTime': sentTime,
  //     };

  @override
  String toString() {
    return "senderId: $senderId , sentTime: $sentTime";
  }
}
