import 'package:flutter/material.dart';
import 'package:homg_long/friends/bloc/friendsPageController.dart';
import 'package:homg_long/friends/friendsList.dart';
import 'package:homg_long/friends/homeFriendsList.dart';
import 'package:logging/logging.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final log = Logger("_FriendsPageState");
  final FriendsPageController controller = FriendsPageController();
  GlobalKey key = GlobalKey();
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
            return CircularProgressIndicator();
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
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          HomeFriendsList(homeFriends: controller.homeFriends),
          Expanded(child: FriendsList(friends: controller.frineds)),
        ],
      ),
    );
  }
}
