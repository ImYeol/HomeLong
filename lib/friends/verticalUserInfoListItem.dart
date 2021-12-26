import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/roundedProfileImage.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

class VerticalUserInfoListItem extends StatelessWidget {
  final log = Logger("FriendsListItem");
  final double height = AppTheme.icon_size * 1.5;
  final double width = AppTheme.icon_size * 2;
  final FriendInfo friend;

  VerticalUserInfoListItem({Key? key, required this.friend}) : super(key: key);

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
            RoundedProfileImage(imageUrl: friend.image),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: width,
              child: Text(friend.name,
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

  Widget defaultImage() {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(AppTheme.emptyUserImage), fit: BoxFit.fill)));
  }

  Widget profileImage() {
    return CachedNetworkImage(
      imageUrl: friend.image,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        print("error: $error");
        return Icon(Icons.error);
      }, // This is what you need
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
      fit: BoxFit.fill,
      fadeInCurve: Curves.easeIn,
      fadeInDuration: Duration(seconds: 2),
      fadeOutCurve: Curves.easeOut,
      fadeOutDuration: Duration(seconds: 2),
    );
  }
}
