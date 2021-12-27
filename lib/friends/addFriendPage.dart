import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/bloc/addFriendPageController.dart';
import 'package:homg_long/friends/roundedProfileImage.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/friendInfo.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:homg_long/utils/ui.dart';

class AddFriendPage extends StatelessWidget {
  late final AddFriendPageController controller;

  AddFriendPage({Key? key}) : super(key: key) {
    controller = AddFriendPageController(
        user: Get.arguments, friendRepository: FriendRepository());
    Get.put(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          title: TitleText(title: "Add Friend", withDivider: false),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: AppTheme.textColor,
            onPressed: () => Get.back(),
          ),
          actions: [Center(child: searchButton())],
        ),
        body: Container(
            color: AppTheme.backgroundColor,
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: AddFriendForm()));
  }

  Widget searchButton() {
    return Obx(() {
      if (controller.inputText.isEmpty) {
        print("controller has no input");
        return TextButton(
            onPressed: () {}, child: normalInvalidTextBox("Search"));
      } else {
        print("controller has input");
        return TextButton(
            onPressed: () => controller.searchFriend(),
            child: normalTextBox("Search"));
      }
    });
  }
}

class AddFriendForm extends StatelessWidget {
  final AddFriendPageController controller =
      Get.find<AddFriendPageController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        addFriendText(),
        idView(),
        Obx(() {
          return Center(
              child: searchResultView(friend: controller.searchedFriend));
        })
      ],
    );
  }

  Widget addFriendText() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
        decoration: new InputDecoration(
            labelText: 'Friend ID',
            labelStyle: TextStyle(color: AppTheme.textColor),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: AppTheme.textColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: AppTheme.smallTextColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(15),
            hintText: 'Input Friend ID',
            hintStyle: TextStyle(color: AppTheme.smallTextColor)),
        onChanged: (String input) {
          controller.inputText = input;
        },
      ),
    );
  }

  Widget idView() {
    return Container(
        alignment: Alignment.centerRight,
        child: smallTextBox("ID : " + controller.user.id));
  }
}

class searchResultView extends StatelessWidget {
  static const _viewWidth = 250.0;
  static const _viewHeight = 150.0;
  final FriendInfo friend;
  final controller = Get.find<AddFriendPageController>();
  searchResultView({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (friend.id.isEmpty) {
      return Container();
    }
    return Container(
        width: _viewWidth,
        height: _viewHeight,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedProfileImage(imageUrl: friend.image),
            knockGuideText(),
            addButton()
          ],
        ));
  }

  Widget knockGuideText() {
    return Text(
      friend.id,
      style: GoogleFonts.lato(
          color: Color(0xFF4F5E7B),
          fontSize: 12,
          fontWeight: FontWeight.normal),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }

  Widget addButton() {
    return ElevatedButton(
        onPressed: () => controller.addFriend(friend),
        child: normalTextBox("SAVE"));
  }
}
