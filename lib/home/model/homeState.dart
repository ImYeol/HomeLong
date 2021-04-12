import 'package:homg_long/home/model/timeData.dart';

abstract class HomeState {
  final TimeData day;
  final TimeData week;
  final TimeData month;

  HomeState({this.day, this.week, this.month});

  TimeData get _day => day;
  TimeData get _week => week;
  TimeData get _month => month;
}

class HomeInit extends HomeState {
  HomeInit()
      : super(day: UnknownTime(), week: UnknownTime(), month: UnknownTime());
}

class UserInfoLoaded extends HomeState {
  UserInfoLoaded()
      : super(day: UnknownTime(), week: UnknownTime(), month: UnknownTime());
}

class DataLoading extends HomeState {
  DataLoading(TimeData day, TimeData week, TimeData month)
      : super(day: day, week: week, month: month);
}

class DataLoaded extends HomeState {
  DataLoaded(TimeData day, TimeData week, TimeData month)
      : super(day: day, week: week, month: month);
}
