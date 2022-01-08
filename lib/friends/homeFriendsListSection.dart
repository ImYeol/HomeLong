import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/bloc/friendsPageController.dart';
import 'package:homg_long/friends/roundedProfileImage.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class HomeFriendsListSection extends StatelessWidget {
  final log = Logger("HomeFriendsList");
  final controller = Get.find<FriendsPageController>();
  // List<UserInfo> homeFriends = [
  //   UserInfo(id: "asdf dd1", name: "asdfdd1", image: ""),
  //   UserInfo(id: "asdf dd12", name: "asdfdd1212341234", image: ""),
  //   UserInfo(id: "asdf dd123", name: "asdfdd12333", image: ""),
  //   UserInfo(id: "asdf dd1234", name: "asdfdd12341234", image: ""),
  //   UserInfo(id: "asdf dd12345", name: "asdfdd12345", image: "")
  // ];

  HomeFriendsListSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [TitleText(title: "At Home"), homeBodyListView()],
      ),
    );
  }

  Widget homeBodyListView() {
    // parent is single child view that has infinite height
    // It needs to set hegiht
    return Obx(() {
      return SizedBox(
        height: AppTheme.icon_size * 2,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.homeFriends.length,
            itemBuilder: (context, index) => GestureDetector(
                  onDoubleTap: () =>
                      controller.knockToFriend(controller.homeFriends[index]),
                  child: HomeFriendsListItem(
                      friend: controller.homeFriends[index]),
                )),
      );
    });
  }
}

class HomeFriendsListItem extends StatelessWidget {
  final log = Logger("HomeFriendsListItem");
  final double height = AppTheme.icon_size * 2;
  final double width = AppTheme.icon_size * 3;

  final FriendInfo friend;

  HomeFriendsListItem({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.info("HomeFriendsListItem size : ${width} : ${height}");
    return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [userProfile(), knockGuideText()],
        ));
  }

  Widget userProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedProfileImage(imageUrl: friend.image),
        Container(
          width: AppTheme.icon_size * 1.5,
          child: Text(
            friend.name,
            style: GoogleFonts.ptSans(
                color: AppTheme.font_color,
                fontSize: 15,
                fontWeight: FontWeight.bold),
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget knockGuideText() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "images/fist.png",
            color: Color(0xFF4F5E7B),
          ),
        ),
        Text(
          "Double tap to knock",
          style: GoogleFonts.lato(
              color: Color(0xFF4F5E7B),
              fontSize: 12,
              fontWeight: FontWeight.normal),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
