import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'bloc/wifi_setting_cubit.dart';

class WifiSettingPage extends StatelessWidget {
  const WifiSettingPage() : super();

  @override
  Widget build(BuildContext context) {
    context.read<WifiSettingCubit>().subscribeWifiEvent();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BlocBuilder<WifiSettingCubit, WifiState>(
          builder: (context, state) {
            if (state is WifiConnected) {
              return HomeWifiSelector(state);
            } else {
              return WarningNoWifiConnection();
            }
          },
        ));
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
              Navigator.pushNamed(context, '/');
            },
            child: Text("NEXT")),
    ]));
  }
}
