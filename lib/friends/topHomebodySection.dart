import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/verticalUserInfoListItem.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/titleText.dart';

class TopHomebodySection extends StatelessWidget {
  List<UserInfo> topHombodyList = [
    UserInfo(id: "asdf dd1", name: "asdf dd1", image: ""),
    UserInfo(id: "asdf dd12", name: "asdf dd12", image: ""),
    UserInfo(id: "asdf dd123", name: "asdf dd123", image: ""),
    UserInfo(id: "asdf dd1234", name: "asdf dd1234", image: ""),
    UserInfo(id: "asdf dd12345", name: "asdf dd12345", image: "")
  ];

  TopHomebodySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [TitleText(title: "Top 5 Homebody"), topHomeBodyListView()],
      ),
    );
  }

  Widget topHomeBodyListView() {
    // parent is single child view that has infinite height
    // It must constrain the height
    return SizedBox(
      height: AppTheme.icon_size * 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topHombodyList.length,
        itemBuilder: (context, index) =>
            VerticalUserInfoListItem(user: topHombodyList[index]),
      ),
    );
  }
}
