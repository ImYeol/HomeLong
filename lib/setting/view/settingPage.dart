import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/setting/bloc/settingCubit.dart';
import 'package:logging/logging.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SettingCubit(),
        child: _SettingPageState(),
      ),
    );
  }
}

class _SettingPageState extends StatelessWidget {
  LogUtil _logUtil = LogUtil();
  final log = Logger("SettingPage");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, InAppUser>(builder: (context, state) {
      return profile(context, state);
    });
  }

  Widget profile(BuildContext context, InAppUser user) {
    if (user == null) {
      return Column(
        children: [Text("Has no user Info")],
      );
    }

    log.info("profile:$user");

    int latSubIdx = user.latitude.toString().indexOf(".");
    String latitude = user.latitude.toString().substring(0, latSubIdx + 3);

    int lngSubIdx = user.longitude.toString().indexOf(".");
    String longitude = user.longitude.toString().substring(0, lngSubIdx + 3);

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          GFListTile(
            avatar: GFAvatar(
              backgroundImage:
                  user.image == null ? null : NetworkImage(user.image),
              size: 60,
            ),
            titleText: user.name,
            color: Colors.white10,
            focusColor: Colors.yellow,
          ),
          GFListTile(
            titleText: "Location",
            subTitleText: "latitude:$latitude, longitude:$longitude",
          ),
          GFListTile(
            titleText: "Address",
            subTitleText: "${user.street}",
          ),
          GFListTile(
            titleText: "Wifi",
            subTitleText: "${user.ssid}, ${user.bssid}",
          ),
          GFButton(
            onPressed: () {
              Navigator.pushNamed(context, '/GPS');
            },
            text: "Change location Info",
            shape: GFButtonShape.pills,
            fullWidthButton: true,
          ),
          GFButton(
            onPressed: () async {
              await DBHelper().deleteUserInfo();
              Navigator.pushNamed(context, '/Login');
            },
            text: "Logout",
            shape: GFButtonShape.pills,
            fullWidthButton: true,
          )
        ]));
  }
}
