import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/rank/models/models.dart';

part 'rank_event.dart';
part 'rank_state.dart';

class RankBloc extends Bloc<RankEvent, RankState> {
  RankBloc() : super(RankLoading());

  bool isAtRank = false;

  @override
  Stream<RankState> mapEventToState(
    RankEvent event,
  ) async* {
    if (event is RankStarted) {
      yield* _mapRankStartedToState();
    } else if (event is UserGotRank) {
      yield* _mapUserGotRankToState(event, state);
    }
  }

  Stream<RankState> _mapRankStartedToState() async* {
    yield RankLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield RankLoaded(rank: Rank());
    } catch (_) {
      yield RankError();
    }
  }

  Stream<RankState> _mapUserGotRankToState(
    UserGotRank event,
    RankState state,
  ) async* {
    if (state is RankLoaded) {
      try {
        yield RankLoaded(
          rank: Rank(),
        );
      } on Exception {
        yield RankError();
      }
    }
  }
}
