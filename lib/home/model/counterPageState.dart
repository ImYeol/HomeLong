abstract class CouterPageState {
  CouterPageState();
}

class CounterPageLoading extends CouterPageState {
  CounterPageLoading() : super();
}

class CounterTickInvoked extends CouterPageState {
  final int atHomeTime;
  final int outHomeTime;

  CounterTickInvoked(this.atHomeTime, this.outHomeTime) : super();
}
