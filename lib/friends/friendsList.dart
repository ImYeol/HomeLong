import 'package:flutter/material.dart';
import 'package:homg_long/friends/model/friendInfo.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:logging/logging.dart';

class FriendsList extends StatelessWidget {
  final log = Logger("FriendsList");
  final List<FriendInfo> friends;

  FriendsList({required this.friends});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info(
        "build : width = $width, height = $height, items = ${friends.length}");
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: height,
      padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection("Friends"),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: friends.length,
                itemBuilder: (context, index) => FriendsListItem(
                      friend: friends[index],
                    )),
          ),
        ],
      ),
    );
  }

  Widget titleSection(String title) {
    return LayoutBuilder(builder: (context, constraints) {
      log.info(
          "FriendsList - titleSection : ${Size(constraints.maxWidth, constraints.maxHeight)}");
      return Text(
        title,
        style: TextStyle(fontSize: 20),
      );
    });
    // return Text(
    //   title,
    //   style: TextStyle(fontSize: 20),
    // );
  }
}

class FriendsListItem extends StatelessWidget {
  final log = Logger("FriendsListItem");
  final FriendInfo friend;

  FriendsListItem({required this.friend});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log.info("build : width = $width, height = $height");
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
      color: Colors.green,
      width: width,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: friend.image == "invalid"
                ? AssetImage(AppTheme.emptyUserImage)
                : AssetImage(AppTheme.emptyUserImage),
          ),
          Text(
            friend.id,
            style: TextStyle(fontSize: 5),
          )
        ],
      ),
    );
  }
}
