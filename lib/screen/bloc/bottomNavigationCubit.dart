import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/bloc/homeCubit.dart';
import 'package:homg_long/home/homePage.dart';
import 'package:homg_long/rank/rank.dart';
import 'package:homg_long/repository/model/UserInfo.dart';
import 'package:homg_long/screen/model/bottomNavigationState.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  static const int HOME_PAGE = 0;
  static const int RANK_PAGE = 0;
  static const int SETTING_PAGE = 0;

  int currentPage = 0;
  UserInfo userInfo;

  HomeCubit homeCubit;
  RankCubit rankCubit;

  BottomNavigationCubit({this.homeCubit, this.rankCubit})
      : super(PageLoading());

  int get _currentPage => currentPage;

  void dispatch(int tappedIndex) {
    switch (tappedIndex) {
      case HOME_PAGE:
        emit(HomePageLoaded(BlocProvider<HomeCubit>.value(
            value: homeCubit, child: HomePage())));
        break;
      case RANK_PAGE:
        emit(RankPageLoaded(BlocProvider<RankCubit>.value(
            value: rankCubit, child: RankPage())));
        break;
      case SETTING_PAGE:
        emit(SettingPageLoaded(BlocProvider<HomeCubit>.value(
            value: homeCubit, child: HomePage())));
    }
  }
}
