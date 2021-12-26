import 'package:flutter/material.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/verticalUserInfoListItem.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class FriendsListSection extends StatelessWidget {
  final log = Logger("FriendsList");
  final List<UserInfo> friends = [
    UserInfo(id: "asdfdd1", name: "asdfdd1", image: ""),
    UserInfo(id: "asdfdd12", name: "asdfdd12", image: ""),
    UserInfo(id: "asdfdd123", name: "asdfdd123", image: ""),
    UserInfo(id: "asdfdd1234", name: "asdfdd1234", image: ""),
    UserInfo(id: "asdfdd12345", name: "asdfdd12345", image: ""),
    UserInfo(id: "asdfdd234", name: "asdfdd234", image: ""),
    UserInfo(id: "asdfdd34", name: "asdfdd34", image: ""),
    UserInfo(id: "asdfdd345", name: "asdfdd345", image: ""),
    UserInfo(id: "asdfdd347", name: "asdfdd347", image: ""),
    UserInfo(id: "asdfdd153464", name: "asdfdd153464", image: ""),
    UserInfo(id: "asdfdd124334", name: "asdfdd124334", image: ""),
  ];

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
      itemCount: friends.length,
      itemBuilder: (context, index) =>
          VerticalUserInfoListItem(user: friends[index]),
    );
  }
}
