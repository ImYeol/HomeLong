import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:homg_long/proxy/model/timeData.dart';
import 'package:http/http.dart' as http;

class TimeDataProxy {
  static final String DataTypeDay = "day";
  static final String DataTypeWeek = "week";
  static final String DataTypeMonth = "month";
  static final String DataTypeAll = "all";

  static final String prefixUrl = "http://testserver/time/";

  static Future<bool> uploadTimeData(
      String id, int date, String dataType) async {
    http.Response response = await http.post(
      Uri.parse(prefixUrl + dataType + "/set"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: <String, dynamic>{'id': id, 'date': date},
    );
    return (response.statusCode == 200);
  }

  static Future<TimeData> fetchAllTimeData(String id, String dataType) async {
    final response = await http.get(Uri.parse(
        prefixUrl + dataType + "/get" + "/" + id + "/" + getNowTime()));

    if (response.statusCode == 200) {
      return compute(parseTimeData, response.body);
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static String getNowTime() {
    var now = DateTime.now();

    return now.year.toString().substring(2, 4) +
        now.month.toString() +
        now.day.toString();
  }

  static TimeData parseTimeData(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody);
    return TimeData.fromJson(parsed);
  }
}
