import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:homg_long/wifi/bloc/wifiSettingController.dart';

class ConnectedView extends StatelessWidget {
  final WifiState wifiState;
  const ConnectedView({Key? key, required this.wifiState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F7F7),
      child: ListTile(
        leading: Icon(
          Icons.wifi,
          size: AppTheme.icon_size,
        ),
        title: titleWidget(),
        subtitle: TitleText(
          title: wifiState.bssid,
          fontColor: Color(0xFF4F5E7B),
          fontWeight: FontWeight.normal,
          fontSize: AppTheme.smallTextSize,
          withDivider: false,
        ),
      ),
    );
  }

  Widget titleWidget() {
    final controller = Get.find<WifiSettingController>();
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TitleText(
          title: wifiState.ssid,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          withDivider: false,
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFF7F7F7))),
            onPressed: () async {
              final user = await UserRepository().getUserInfo();
              // controller.postWifiAPInfo(
              //     user.id, wifiState.ssid, wifiState.bssid);
              controller.updateWifiInfo(wifiState.ssid, wifiState.bssid);
              Get.offAndToNamed("/Main");
            },
            child: TitleText(
              title: "select",
              fontSize: AppTheme.smallTextSize,
              fontColor: Color(0xFF4F5E7B),
              withDivider: false,
            ))
      ]),
    );
  }
}
