import 'package:flutter/material.dart';
import 'package:homg_long/friends/model/friendInfo.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:logging/logging.dart';

class HomeFriendsList extends StatelessWidget {
  final log = Logger("HomeFriendsList");
  final List<FriendInfo> homeFriends;

  HomeFriendsList({required this.homeFriends});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info("build : width = ${width * 0.95}, height = ${width * 0.95 * 0.5}");
    return Container(
      color: Colors.blue,
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.width * 0.95 * 0.5,
      padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection("Home - double tap"),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeFriends.length,
                  itemBuilder: (context, index) => CircleUserProfile(
                        friend: homeFriends[index],
                      ))),
        ],
      ),
    );
  }

  Widget titleSection(String title) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(
        title,
      ),
    );
  }
}

class CircleUserProfile extends StatelessWidget {
  final log = Logger("CircleUserProfile");
  final FriendInfo friend;

  CircleUserProfile({required this.friend});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info("build : width = $width, height = $height");

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.green,
      width: width / 8,
      child: Center(
        child: Column(
          children: [circleImage(width / 5, height), titleSection(friend.name)],
        ),
      ),
    );
  }

  Widget circleImage(double width, double height) {
    return Flexible(
        fit: FlexFit.loose,
        child: CircleAvatar(
          radius: width / 2,
          backgroundImage: friend.image == "invalid"
              ? AssetImage(AppTheme.emptyUserImage)
              : AssetImage(AppTheme.emptyUserImage),
        ));
  }

  Widget titleSection(String title) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        title,
      ),
    );
  }
}
