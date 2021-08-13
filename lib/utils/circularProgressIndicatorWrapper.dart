import 'package:flutter/material.dart';

class CircularProgressIndicatorWrapper extends StatelessWidget {
  const CircularProgressIndicatorWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()));
  }
}