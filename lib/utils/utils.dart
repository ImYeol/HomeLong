import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

showToast(String msg) {
  Fluttertoast.showToast(
    msg: "$msg",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blue[100],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
