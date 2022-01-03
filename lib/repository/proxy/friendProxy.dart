import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:homg_long/const/StatusCode.dart';
import 'package:homg_long/const/URL.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/proxy/friendApiHeader.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

final log = Logger("FriendProxy");

Future<List<FriendInfo>> getAllFriendInfo(String uid) async {
  log.info("getFriendInfo");
  var response = await http.get(
    URL.getAllFriendURL,
    headers: FriendApiHeader.builder(uid, uid),
  );

  if (response.statusCode == StatusCode.statusOK && response.body != 'null') {
    log.info("getAllFriendInfo success(${response.body})");
    // compute can't be used in instance. It only used as top level function
    return compute(parseFriendInfo, response.body);
  } else {
    log.info("getAllFriendInfo fail(${response.statusCode}, ${response.body})");
    return <FriendInfo>[];
  }
}

List<FriendInfo> parseFriendInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<FriendInfo>((json) => FriendInfo.fromJson(json)).toList();
}

Future<bool> setFriendInfo(String uid, String fid) async {
  log.info("setFriendInfo");

  var response = await http.post(
    URL.setFriendURL,
    headers: FriendApiHeader.builder(uid, fid),
  );

  if (response.statusCode == StatusCode.statusOK) {
    log.info("setFriendInfo success");
    return true;
  } else {
    log.info("setFriendInfo fail(${response.statusCode}, ${response.body})");
    return false;
  }
}

Future<FriendInfo> getFriendInfo(String uid, String fid) async {
  log.info("getFriendInfo");
  var response = await http.get(
    URL.getFriendURL,
    headers: FriendApiHeader.builder(uid, fid),
  );

  if (response.statusCode == StatusCode.statusOK) {
    log.info("getFriendInfo success(${response.body}");
    return FriendInfo.fromJson(json.decode(response.body));
  } else {
    log.info("getFriendInfo fail(${response.statusCode}, ${response.body})");
    return FriendInfo.invalidFriend();
  }
}

Future<bool> deleteFriendInfo(String uid, String fid) async {
  log.info("deleteFriendInfo");

  var response = await http.get(
    URL.deleteFriendURL,
    headers: FriendApiHeader.builder(uid, fid),
  );

  if (response.statusCode == StatusCode.statusOK) {
    log.info("deleteFriendInfo success");
    return true;
  } else {
    log.info("deleteFriendInfo fail(${response.statusCode}, ${response.body})");
    return false;
  }
}

Future<bool> sendKnockMessage(String uid, String fid) async {
  log.info("sendKnockMessage to $fid");
  var response = await http.get(
    URL.sendKnockURL,
    headers: {'id': uid, 'fid': fid, 'time': DateTime.now().toString()},
  );

  if (response.statusCode == StatusCode.statusOK) {
    log.info("sendKnockMessage success(${response.body}");
    return true;
  } else {
    log.info("sendKnockMessage fail(${response.statusCode}, ${response.body})");
    return false;
  }
}
