import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/bloc/friendsPageController.dart';
import 'package:homg_long/friends/verticalUserInfoListItem.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class FriendsListSection extends StatelessWidget {
  final log = Logger("FriendsList");
  final controller = Get.find<FriendsPageController>();

  FriendsListSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [TitleText(title: "Friends"), friendListView()],
      ),
    );
  }

  Widget friendListView() {
    // parent is single child view that has infinite height
    // It needs to set hegiht
    return Obx(() {
      return GridView.builder(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppTheme.icon_size * 2,
          mainAxisExtent: AppTheme.icon_size * 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: controller.frineds.length,
        itemBuilder: (context, index) => GestureDetector(
          onLongPress: () => Get.defaultDialog(
              title: "Delete",
              middleText: "${controller.frineds[index].id}",
              onConfirm: () {
                controller.deleteFriend(controller.frineds[index]);
                Get.back();
              },
              onCancel: () {
                Get.back();
              }),
          child: VerticalUserInfoListItem(friend: controller.frineds[index]),
        ),
      );
    });
  }
}
