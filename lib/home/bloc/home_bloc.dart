import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/home/models/models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading());

  bool isAtHome = false;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeStarted) {
      yield* _mapHomeStartedToState();
    } else if (event is UserGotHome) {
      yield* _mapUserGotHomeToState(event, state);
    }
  }

  Stream<HomeState> _mapHomeStartedToState() async* {
    yield HomeLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield HomeLoaded(
          home:
              Home(title: isAtHome ? Home.AT_HOME_TITLE : Home.OUT_HOME_TITLE));
    } catch (_) {
      yield HomeError();
    }
  }

  Stream<HomeState> _mapUserGotHomeToState(
    UserGotHome event,
    HomeState state,
  ) async* {
    if (state is HomeLoaded) {
      try {
        yield HomeLoaded(
          home: Home(),
        );
      } on Exception {
        yield HomeError();
      }
    }
  }
}
