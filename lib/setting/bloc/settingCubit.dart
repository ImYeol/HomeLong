import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/model/InAppUser.dart';

class SettingCubit extends Cubit<InAppUser> {
  SettingCubit() : super(null) {
    this.getUserInfo();
  }

  getUserInfo() async {
    InAppUser _user = await DBHelper().getUser();
    if (_user != null) {
      emit(_user);
    }
  }
}
