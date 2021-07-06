import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/db/DBHelper.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:logging/logging.dart';

import 'bloc/wifi_setting_cubit.dart';

class WifiSettingPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  final log = Logger("WifiSettingPage");

  WifiSettingPage() : super();

  @override
  Widget build(BuildContext context) {
    log.info("build wifi page");
    return Scaffold(
        backgroundColor: Colors.brown[900],
        body: BlocProvider(
          create: (_) =>
              WifiSettingCubit(context.read<WifiConnectionService>()),
          child: WifiSettingForm(),
        ));
  }
}

class WifiSettingForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // context.read<WifiSettingCubit>().subscribeWifiEvent();
    return BlocBuilder<WifiSettingCubit, WifiState>(
      builder: (context, state) {
        if (state is WifiConnected) {
          return HomeWifiSelector(state);
        } else {
          return WarningNoWifiConnection();
        }
      },
    );
  }
}

class MessageTextView extends StatelessWidget {
  final String message;
  final double fontSize;
  final Color fontColor;

  MessageTextView({this.message, this.fontSize, this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.ubuntu(
              fontSize: fontSize,
              color: fontColor,
              fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class WarningNoWifiConnection extends StatelessWidget {
  final String title = "NO Wifi Connection";
  final String contents = "Please Connect to Home Wifi First";
  final double iconSize = 150;
  final double titleSize = 30;
  final double subTitleSize = 20;
  final Color titleColor = Colors.white;
  final Color subTitleColor = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: iconSize,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            MessageTextView(
                message: "NO WIFI CONNECTION",
                fontSize: titleSize,
                fontColor: titleColor),
            SizedBox(
              height: 10,
            ),
            MessageTextView(
                message: "please connect to home wifi",
                fontSize: subTitleSize,
                fontColor: subTitleColor)
          ]),
    );
  }
}

class HomeWifiSelector extends StatelessWidget {
  final WifiState connInfo;
  final String title = "Select the Item for Home Wifi";
  final double iconSize = 150;
  final double titleSize = 30;
  final double subTitleSize = 20;
  final Color titleColor = Colors.white;
  final Color subTitleColor = Colors.white54;

  HomeWifiSelector(this.connInfo);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WifiSettingCubit, WifiState>(
        listener: (context, state) {
          if (state is WifiInfoSaved) {
            Navigator.pushNamed(context, '/Main');
          }
        },
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              MessageTextView(
                  message: "SAVE IT AS HOME WIFI",
                  fontSize: titleSize,
                  fontColor: titleColor),
              SizedBox(height: 30),
              buildWifiInfoCardWidget(
                  connInfo.ssid == null ? "unknonw" : connInfo.ssid,
                  connInfo.bssid == null ? "unknonw" : connInfo.bssid),
              SizedBox(height: 20),
              buildSaveWifiButton(context),
            ])));
  }

  Widget buildWifiInfoCardWidget(String ssid, String bssid) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 100,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.brown[400],
            elevation: 10,
            child: Center(
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white30))),
                  child: Icon(Icons.wifi, size: 50, color: Colors.white),
                ),
                title: buildCardText(ssid, bssid),
              ),
            )));
  }

  Widget buildCardText(String ssid, String bssid) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      MessageTextView(
        fontColor: Colors.white,
        fontSize: 20,
        message: ssid,
      ),
      MessageTextView(
        fontColor: Colors.white54,
        fontSize: 15,
        message: bssid,
      )
    ]));
  }

  Widget buildSaveWifiButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          DBHelper().updateWifiInfo(connInfo.ssid, connInfo.bssid);
          // context.read<WifiSettingCubit>().postWifiAPInfo(
          //     userInfo.id, connInfo.ssid, connInfo.bssid);
          Navigator.pushNamed(context, "/Main");
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.purple[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: Center(
                child: Text(
              "SAVE",
              style: GoogleFonts.ubuntu(
                  fontSize: titleSize,
                  color: titleColor,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ))));
  }
}
