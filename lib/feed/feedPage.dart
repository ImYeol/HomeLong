import 'package:flutter/material.dart';
import 'package:homg_long/feed/KnockFeedListItem.dart';
import 'package:homg_long/feed/bloc/feedPageController.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/knockFeed.dart';
import 'package:homg_long/utils/titleText.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final controller = FeedPageController(repository: FriendRepository());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [TitleText(title: "Knock Knock"), KnockFeedList()],
          )),
    );
  }

  Widget KnockFeedList() {
    return FutureBuilder(
      future: controller.loadFriends(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("error"),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            final items = snapshot.data as List<KnockFeed>;
            print("feed page : items.len : ${items.length}");
            return Container(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) =>
                      KnockFeedListItem(feed: items[index])),
            );
          default:
            return Container();
        }
      },
    );
  }
}
