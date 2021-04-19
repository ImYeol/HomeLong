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
      prefixUrl + dataType + "/set",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: <String, dynamic>{'id': id, 'date': date},
    );
    return (response.statusCode == 200);
  }

  static Future<List<TimeData>> fetchAllTimeData(
      String id, String dataType) async {
    DateTime now = DateTime.now();
    final response = await http.get(prefixUrl + dataType + "/get");

    if (response.statusCode == 200) {
      return compute(parseTimeData, response.body);
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  // 응답 결과를 List<TimeData>로 변환하는 함수.
  static List<TimeData> parseTimeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<TimeData>((json) => TimeData.fromJson(json)).toList();
  }
}
