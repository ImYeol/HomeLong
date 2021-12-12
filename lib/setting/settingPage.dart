import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/cubit/loginController.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/setting/bloc/settingCubit.dart';
import 'package:homg_long/utils/ui.dart';
import 'package:logging/logging.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
    return BlocBuilder<SettingCubit, UserInfo>(builder: (context, state) {
      return profile(context, state);
    });
  }

  Widget profile(BuildContext context, UserInfo user) {
    if (user == null) {
      return Column(
        children: [Text("Has no user Info")],
      );
    }
    log.info("profile:$user");

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 64,
            height: 64,
            child: ExtendedImage.network(
              user.image,
              fit: BoxFit.fill,
              cache: true,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            width: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  normalTextBox(user.name),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: 150,
                    child: smallTextBox(user.street),
                  ),
                ]),
          ),
        ]),
        // Container(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       Container(
        //         margin: const EdgeInsets.only(left: 30.0, top: 30.0),
        //         width: 24,
        //         height: 24,
        //         child: Image(image: AssetImage('images/dark_mode.png')),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(left: 20.0, top: 30.0),
        //         alignment: Alignment.center,
        //         child: smallTextBox("Dark mode"),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/GPS');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0, top: 30.0),
                  width: 24,
                  height: 24,
                  child: Image(image: AssetImage('images/gps_setting.png')),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, top: 30.0),
                  alignment: Alignment.center,
                  child: smallTextBox("GPS setting"),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Wifi');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0, top: 30.0),
                  width: 24,
                  height: 24,
                  child: Image(image: AssetImage('images/wifi_setting.png')),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, top: 30.0),
                  alignment: Alignment.center,
                  child: smallTextBox("WIFI setting"),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              Get.find<LoginController>().logOut();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0, top: 30.0),
                  width: 24,
                  height: 24,
                  child: Image(image: AssetImage('images/logout.png')),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, top: 30.0),
                  alignment: Alignment.center,
                  child: smallTextBox("Logout"),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
