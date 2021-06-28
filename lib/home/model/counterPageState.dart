abstract class CouterPageState {
  CouterPageState();
}

class PageLoading extends CouterPageState {
  PageLoading() : super();
}

class CounterTickInvoked extends CouterPageState {
  final int atHomeTime;
  final int outHomeTime;
  final int noDeterminatedTime;

  CounterTickInvoked(this.atHomeTime, this.outHomeTime, this.noDeterminatedTime)
      : super();
}
