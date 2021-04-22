import 'package:homg_long/proxy/model/timeData.dart';

abstract class HomeState {
  TimeData time;

  HomeState({this.time});

  TimeData get _time => time;
}

class TimeDataLoading extends HomeState {
  TimeDataLoading(TimeData data) : super(time: data);
}

class TimeDataLoaded extends HomeState {
  TimeDataLoaded(TimeData data) : super(time: data);
}
