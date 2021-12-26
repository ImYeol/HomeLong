import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homg_long/const/AppTheme.dart';

class RoundedProfileImage extends StatelessWidget {
  final String imageUrl;
  const RoundedProfileImage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool setDefaultImage = imageUrl.isEmpty;
    return Container(
      width: AppTheme.icon_size,
      height: AppTheme.icon_size,
      child: setDefaultImage ? defaultImage() : profileImage(),
    );
  }

  Widget defaultImage() {
    return CircleAvatar(
      radius: AppTheme.icon_size / 2,
      backgroundImage: AssetImage(AppTheme.emptyUserImage),
    );
  }

  Widget profileImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
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
