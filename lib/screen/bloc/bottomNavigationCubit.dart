import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/home/homePage.dart';
import 'package:homg_long/rank/rank.dart';
import 'package:homg_long/repository/model/UserInfo.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';
import 'package:homg_long/screen/model/bottomNavigationState.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 1;
  static const int SETTING_PAGE = 2;

  int currentPage = 0;
  UserInfo userInfo;

  HomeCubit homeCubit;
  RankCubit rankCubit;

  BottomNavigationCubit({this.homeCubit, this.rankCubit})
      : super(PageLoading());

  int get _currentPage => currentPage;

  void init(BuildContext context) {
    context.watch<WifiConnectionService>().init();
    dispatch(currentPage);
  }

  void dispatch(int tappedIndex) {
    currentPage = tappedIndex;
    switch (tappedIndex) {
      case HOME_PAGE:
        emit(HomePageLoaded(BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(), child: HomePage())));
        break;
      case RANK_PAGE:
        emit(RankPageLoaded(BlocProvider<RankCubit>(
            create: (context) => RankCubit(), child: RankPage())));
        break;
      case SETTING_PAGE:
        emit(SettingPageLoaded(BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(), child: HomePage())));
    }
  }
}
