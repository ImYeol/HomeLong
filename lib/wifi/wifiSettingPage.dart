import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/cubit/loginController.dart';
import 'package:homg_long/repository/ConnectivityServiceWrapper.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:homg_long/wifi/connectedView.dart';
import 'package:homg_long/wifi/disconnectedView.dart';
import 'package:logging/logging.dart';

import 'bloc/wifiSettingController.dart';

class WifiSettingPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  final log = Logger("WifiSettingPage");
  final controller = Get.put(WifiSettingController());

  WifiSettingPage() : super();

  @override
  Widget build(BuildContext context) {
    log.info("build wifi page");
    controller.subscribeWifiEvent();
    controller.checkCurrentWifiInfo();
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: "WIFI Setting",
                    fontSize: 30,
                    withDivider: false,
                    align: TextAlign.start,
                  ),
                  Container(
                    height: 10,
                  ),
                  TitleText(
                    title: "Please select home wifi",
                    fontColor: AppTheme.smallTextColor,
                    fontSize: 15,
                  ),
                  Obx(() {
                    if (controller.wifiState.value is WifiConnected) {
                      return ConnectedView(
                          wifiState: controller.wifiState.value);
                    } else {
                      return DisconnectedView();
                    }
                  })
                ],
              )),
        ));
  }
}
