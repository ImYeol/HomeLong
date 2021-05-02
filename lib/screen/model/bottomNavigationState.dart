import 'package:flutter/material.dart';
import 'package:homg_long/repository/model/UserInfo.dart';

abstract class BottomNavigationState {
  Widget widget;

  BottomNavigationState({this.widget});

  Widget get _widget => widget;
}

class PageLoading extends BottomNavigationState {}

class HomePageLoaded extends BottomNavigationState {
  HomePageLoaded(Widget widget) : super(widget: widget);
}

class RankPageLoaded extends BottomNavigationState {
  RankPageLoaded(Widget widget) : super(widget: widget);
}

class SettingPageLoaded extends BottomNavigationState {
  SettingPageLoaded(Widget widget) : super(widget: widget);
}
