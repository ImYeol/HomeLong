part of 'rank_bloc.dart';

@immutable
abstract class RankState extends Equatable {
  const RankState();
}

class RankLoading extends RankState {
  @override
  List<Object> get props => [];
}

class RankLoaded extends RankState {
  const RankLoaded({this.rank});

  final Rank rank;

  @override
  List<Object> get props => [rank];
}

class RankError extends RankState {
  @override
  List<Object> get props => [];
}
