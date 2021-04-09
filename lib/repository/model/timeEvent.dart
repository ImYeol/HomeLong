abstract class TimeEvent {
  final int value;

  const TimeEvent({this.value});

  int get _value => value;
}

class OnMinuteTimeEvent extends TimeEvent {
  OnMinuteTimeEvent(int value) : super(value: value);
}

class OnHourTimeEvent extends TimeEvent {
  OnHourTimeEvent(int value) : super(value: value);
}
