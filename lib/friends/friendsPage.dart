import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/bloc/friendsPageController.dart';
import 'package:homg_long/friends/friendsListSection.dart';
import 'package:homg_long/friends/homeFriendsListSection.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class FriendPage extends StatelessWidget {
  final log = Logger("_FriendsPageState");
  final controller = Get.put(FriendsPageController(
      userRepository: UserRepository(), friendRepository: FriendRepository()));
  FriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info("build : width = $width, height = $height");
    controller.loadFreinds();
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
            onPressed: () => controller.goToSearchPage(),
          ),
        )
      ],
    );
  }
}
