import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'bloc/wifi_setting_cubit.dart';

class WifiSettingPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  WifiSettingPage() : super();

  @override
  Widget build(BuildContext context) {
    logUtil.logger.d("build wifi page");
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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

class WarningNoWifiConnection extends StatelessWidget {
  final String title = "NO Wifi Connection";
  final String contents = "Please Connect to Home Wifi First";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 100,
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_small,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(
        height: 50,
      ),
      Text(
        contents,
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_middle,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ]));
  }
}

class HomeWifiSelector extends StatelessWidget {
  final WifiState connInfo;
  final String title = "Select the Item for Home Wifi";
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
                children: [
              SizedBox(
                height: 100,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: AppTheme.subtitle_font_size_small,
                    color: AppTheme.font_color,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                connInfo.bssid == null ? "unknonw" : connInfo.ssid,
                style: TextStyle(
                    fontSize: AppTheme.header_font_size,
                    color: AppTheme.font_color,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                connInfo.bssid == null ? "unknonw" : connInfo.bssid,
                style: TextStyle(
                    fontSize: AppTheme.header_font_size,
                    color: AppTheme.font_color,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (connInfo.bssid != null)
                TextButton(
                    onPressed: () {
                      DBHelper().updateWifiInfo(connInfo.ssid, connInfo.bssid);
                      // context.read<WifiSettingCubit>().postWifiAPInfo(
                      //     userInfo.id, connInfo.ssid, connInfo.bssid);
                      Navigator.pushNamed(context, "/Main");
                    },
                    child: Text("NEXT")),
            ])));
  }
}
