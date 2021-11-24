import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:logging/logging.dart';

class VerticalUserInfoListItem extends StatelessWidget {
  final log = Logger("FriendsListItem");
  final double height = AppTheme.icon_size * 1.5;
  final double width = AppTheme.icon_size * 2;
  final UserInfo user;

  VerticalUserInfoListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("VerticalUserInfoListItem size : ${width} : ${height}");
    return Container(
        padding: EdgeInsets.only(top: 7),
        width: width,
        height: height,
        //margin: EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: AppTheme.icon_size / 2,
              backgroundImage: user.image == "invalid"
                  ? AssetImage(AppTheme.emptyUserImage)
                  : AssetImage(AppTheme.emptyUserImage),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: width,
              child: Text(user.name,
                  style: GoogleFonts.ptSans(
                      color: AppTheme.font_color,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ));
  }
}
