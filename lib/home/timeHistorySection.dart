import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:homg_long/utils/titleText.dart';

class TimeHistorySection extends StatelessWidget {
  List<HomeTime>? timeHistoryList;
  List<HomeTime> tempHistoryList = [
    HomeTime(
        enterTime: "2014-02-15 08:57:47.812",
        exitTime: "2014-02-15 09:57:47.812",
        description: "home"),
    HomeTime(
        enterTime: "2014-02-15 10:57:47.812",
        exitTime: "2014-02-15 11:57:47.812",
        description: "home"),
    HomeTime(
        enterTime: "2014-02-15 12:57:47.812",
        exitTime: "2014-02-15 13:57:47.812",
        description: "home"),
    HomeTime(
        enterTime: "2014-02-15 14:57:47.812",
        exitTime: "2014-02-15 15:57:47.812",
        description: "home"),
    HomeTime(
        enterTime: "2014-02-15 16:57:47.812",
        exitTime: "2014-02-15 17:57:47.812",
        description: "home"),
  ];

  TimeHistorySection({Key? key, this.timeHistoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("timeHistorySection build");
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: "Today history"),
          timeHistoryListView(),
        ],
      ),
    );
  }

  Widget timeHistoryListView() {
    timeHistoryList = tempHistoryList;
    print("timeHistoryList is : $timeHistoryList");
    if (timeHistoryList == null || timeHistoryList!.length == 0) {
      print("timeHistoryList is null : $timeHistoryList");
      return Container();
    }
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: timeHistoryList!.length,
        itemBuilder: (context, index) =>
            TimeHistoryListItem(homeTime: timeHistoryList![index]));
  }
}

class TimeHistoryListItem extends StatelessWidget {
  final HomeTime homeTime;

  const TimeHistoryListItem({Key? key, required this.homeTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
      ),
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.home, size: 25),
            Container(
              width: 10,
            ),
            Text("duration",
                style: GoogleFonts.ptSans(
                    color: AppTheme.font_color,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))
          ],
        ),
        subtitle: Text(
            "${extractHourAndMinute(homeTime.enterTime)}  -  ${extractHourAndMinute(homeTime.exitTime)}",
            style: GoogleFonts.quicksand(
                color: Color(0xFF2B2B2B),
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  String extractHourAndMinute(String stringFormattedTime) {
    DateTime date = DateTime.parse(stringFormattedTime);
    return "${date.hour}:${date.minute}";
  }
}
