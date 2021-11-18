import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:homg_long/const/HiveTypeId.dart';

@HiveType(typeId: HiveTypeId.HIVE_FRIEND_INFO_ID)
class FriendInfo {
  static final String invalid_id = "invalid".hashCode.toString();

  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;

  FriendInfo({required this.id, required this.name, required this.image});

  FriendInfo.empty()
      : id = invalid_id,
        name = "invalid",
        image = "invalid";

  FriendInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? invalid_id,
        name = json['name'] ?? "invalid",
        image = json['image'] ?? "invalid";

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
    };
  }
}
