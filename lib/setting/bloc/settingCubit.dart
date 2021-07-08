import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/db/DBHelper.dart';
import 'package:homg_long/repository/model/userInfo.dart';

class SettingCubit extends Cubit<UserInfo> {
  SettingCubit() : super(null) {
    this.getUserInfo();
  }

  getUserInfo() async {
    UserInfo _user = await DBHelper().getUserInfo();
    if (_user != null) {
      emit(_user);
    }
  }
}
