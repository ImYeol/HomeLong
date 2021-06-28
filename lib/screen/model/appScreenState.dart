import 'package:flutter/material.dart';

abstract class AppScreenState {
  Widget widget;

  AppScreenState(this.widget);
}

class PageLoading extends AppScreenState {
  PageLoading(Widget widget) : super(widget);
}

class CounterPageLoaded extends AppScreenState {
  CounterPageLoaded(Widget widget) : super(widget);
}

class RankPageLoaded extends AppScreenState {
  RankPageLoaded(Widget widget) : super(widget);
}

class SettingPageLoaded extends AppScreenState {
  SettingPageLoaded(Widget widget) : super(widget);
}
