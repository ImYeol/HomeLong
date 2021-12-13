import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/friends/bloc/friendsPageController.dart';
import 'package:homg_long/friends/friendsListSection.dart';
import 'package:homg_long/friends/homeFriendsListSection.dart';
import 'package:homg_long/friends/topHomebodySection.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final log = Logger("_FriendsPageState");
  final FriendsPageController controller = FriendsPageController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info("build : width = $width, height = $height");
    return FutureBuilder(
      future: controller.loadFreinds(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            log.info("waiting");
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            log.info("load done");
            return pageContent(context);
          default:
            log.info("load default ${snapshot.connectionState}");
            return Container(
              width: width,
              height: height,
              color: Colors.black,
            );
        }
      },
    );
  }

  Widget pageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        color: Colors.white,
        child: Column(
          children: [
            titleSection(),
            Container(
              height: 20,
            ),
            TopHomebodySection(),
            HomeFriendsListSection(),
            Container(
              height: 10,
            ),
            FriendsListSection()
          ],
        ),
      ),
    );
  }

  Widget titleSection() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: TitleText(
            title: "HomeBody",
            withDivider: false,
            fontSize: 25,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.person_add),
            iconSize: 30,
            onPressed: () {
              Get.toNamed('AddFriend');
            },
          ),
        )
      ],
    );
  }
}
