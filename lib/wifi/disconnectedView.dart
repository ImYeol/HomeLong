import 'package:flutter/material.dart';
import 'package:homg_long/utils/titleText.dart';

class DisconnectedView extends StatelessWidget {
  const DisconnectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.wifi_off,
              size: 100,
              color: Color(0xFF4F5E7B),
            ),
            TitleText(
              title: "Please Connect to Wifi",
              fontColor: Color(0xFF4F5E7B),
              withDivider: false,
            )
          ],
        ),
      ),
    );
  }
}
