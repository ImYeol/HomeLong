import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/model/knockFeed.dart';
import 'package:homg_long/utils/titleText.dart';

class KnockFeedListItem extends StatelessWidget {
  final KnockFeed feed;
  double height = 0;
  KnockFeedListItem({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
            radius: AppTheme.icon_size / 2,
            backgroundImage: AssetImage(AppTheme.emptyUserImage)),
        title: titleWidget(),
        subtitle: TitleText(
          title: "Knock Knock",
          fontColor: Color(0xFF4F5E7B),
          fontWeight: FontWeight.normal,
          fontSize: 12,
          withDivider: false,
        ),
      ),
    );
  }

  Widget titleWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(
            title: feed.senderId,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            withDivider: false,
          ),
          Text(
            dateTime(),
            style: GoogleFonts.lato(
                color: Color(0xFF4F5E7B),
                fontSize: 15,
                fontWeight: FontWeight.normal),
            softWrap: true,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  String dateTime() {
    DateTime date = DateTime.parse(feed.sentTime);
    // return "${date.month}.${date.day}\n${date.hour}:${date.minute}";
    return "${date.hour}:${date.minute}";
  }
}
