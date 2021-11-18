import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/feed/bloc/feedPageController.dart';
import 'package:homg_long/feed/model/knockFeed.dart';
import 'package:homg_long/utils/titleText.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final controller = FeedPageController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [TitleText(title: "Knock Knock"), KnockFeedList()],
        ));
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
            return Expanded(
              child: ListView.builder(
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

class KnockFeedListItem extends StatelessWidget {
  final KnockFeed feed;
  double height = 0;
  KnockFeedListItem({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 10;
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [profileSection(), dateTime()],
      ),
    );
  }

  Widget profileSection() {
    return Row(
      children: [
        circleImage(),
        Text(
          "${feed.name}",
          style: GoogleFonts.ptSans(
              fontSize: AppTheme.subtitle_font_size_small,
              color: AppTheme.font_color,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget circleImage() {
    final defaultImage = Image.asset(AppTheme.emptyUserImage);
    //final image = FadeInImage.assetNetwork(image: feed.image, placeholder: AppTheme.emptyUserImage,);
    return Container(
      width: height,
      decoration:
          BoxDecoration(color: Color(0xffffffff), shape: BoxShape.circle),
      child: defaultImage,
    );
  }

  Widget dateTime() {
    DateTime date = DateTime.parse(feed.date);
    return Text(
      "${date.month}.${date.day}\n${date.hour}:${date.minute}",
      style: GoogleFonts.ptSans(
          fontSize: AppTheme.subtitle_font_size_small,
          color: AppTheme.font_color,
          fontWeight: FontWeight.bold),
    );
  }
}
