part of 'rank_bloc.dart';

@immutable
abstract class RankEvent extends Equatable {
  const RankEvent();
}

class RankStarted extends RankEvent {
  @override
  List<Object> get props => [];
}

class UserGotRank extends RankEvent {
  @override
  List<Object> get props => [];
}
