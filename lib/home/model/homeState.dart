abstract class HomeState {
  HomeState();
}

class HomeInit extends HomeState {
  HomeInit();
}

class DataLoading extends HomeState {
  DataLoading();
}

class DataLoaded extends HomeState {
  DataLoaded();
}

class DayTimeChanged extends HomeState {
  final int hour;
  final int minute;

  DayTimeChanged({this.hour, this.minute});

  int get _hour => hour;
  int get _minute => minute;

  @override
  String toString() {
    return hour.toString() + " : " + minute.toString();
  }
}

class WeekTimeChanged extends HomeState {
  final int hour;
  final int minute;

  WeekTimeChanged({this.hour, this.minute});

  int get _hour => hour;
  int get _minute => minute;

  @override
  String toString() {
    return hour.toString() + " : " + minute.toString();
  }
}

class MonthTimeChanged extends HomeState {
  final int hour;
  final int minute;

  MonthTimeChanged({this.hour, this.minute});

  int get _hour => hour;
  int get _minute => minute;

  @override
  String toString() {
    return hour.toString() + " : " + minute.toString();
  }
}