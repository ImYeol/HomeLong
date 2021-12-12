import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/bloc/timeHistoryController.dart';
import 'package:homg_long/repository/model/homeTime.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:logging/logging.dart';

class TimeHistorySection extends StatelessWidget {
  final log = Logger("TimeHistorySection");
  TimeHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.info("timeHistorySection build");
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
    final controller = Get.find<TimeHistoryController>();
    final timeHistoryList = controller.timeHistory;
    log.info("timeHistoryList is : $timeHistoryList");
    if (timeHistoryList.length == 0) {
      return Container();
    }
    return Obx(() {
      return ListView.builder(
          primary: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: timeHistoryList.length,
          itemBuilder: (context, index) =>
              TimeHistoryListItem(homeTime: timeHistoryList[index]));
    });
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
