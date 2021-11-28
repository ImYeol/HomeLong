import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/model/userInfo.dart';
import 'package:homg_long/repository/userRepository.dart';

class SettingCubit extends Cubit<UserInfo> {
  SettingCubit() : super(null) {
    this.getUserInfo();
  }

  getUserInfo() async {
    UserInfo _user = await UserRepository().getUserInfo();
    emit(_user);
  }
}
