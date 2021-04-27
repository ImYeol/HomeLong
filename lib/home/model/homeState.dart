import 'package:homg_long/proxy/model/timeData.dart';

abstract class HomeState {
  TimeData time;

  HomeState({this.time});

  TimeData get _time => time;
}

class TimeDataLoading extends HomeState {
  TimeDataLoading() : super(time: TimeData());
}

class TimeDataLoaded extends HomeState {
  TimeDataLoaded(TimeData data) : super(time: data);
}

class TimeDataSaving extends HomeState {
  TimeDataSaving() : super(time: TimeData());
}

class TimeDataSaved extends HomeState {
  TimeDataSaved() : super(time: TimeData());
}

class TimeDataError extends HomeState {
  TimeDataError(TimeData data) : super(time: data);
}
