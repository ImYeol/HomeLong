import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/friends/bloc/addFriendPageController.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/utils/titleText.dart';
import 'package:homg_long/utils/ui.dart';

class AddFriendPage extends StatelessWidget {
  AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: AppTheme.backgroundColor,
            padding: EdgeInsets.only(left: 20, top: 50, right: 20),
            child: AddFriendForm()));
  }
}

class AddFriendForm extends StatelessWidget {
  final AddFriendPageController controller = AddFriendPageController();
  late UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.loadUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              userInfo = snapshot.data as UserInfo;
              return addFriend(userInfo);
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget addFriend(UserInfo userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: TitleText(title: "Add Friend"),
        ),
        addFriendText(),
        idView(),
        saveBackButton(),
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
          if (input.isEmpty) {
            controller.off();
          } else {
            controller.on();
          }
        },
      ),
    );
  }

  Widget idView() {
    return Container(
        alignment: Alignment.centerRight,
        child: smallTextBox("ID : " + userInfo.id));
  }

  Widget saveBackButton() {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GetBuilder<AddFriendPageController>(
                init: controller,
                builder: (_) => controller.getHasInput()
                    ? TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: normalTextBox("SAVE"))
                    : TextButton(
                        onPressed: () {}, child: normalInvalidTextBox("SAVE"))),
            Container(
                // padding: EdgeInsets.only(left: 5),
                child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: normalTextBox("BACK"),
            ))
          ],
        ));
  }
}
