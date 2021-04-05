import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/setting/model/models.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingLoading());

  bool isAtSetting = false;

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if (event is SettingStarted) {
      yield* _mapSettingStartedToState();
    } else if (event is UserGotSetting) {
      yield* _mapUserGotSettingToState(event, state);
    }
  }

  Stream<SettingState> _mapSettingStartedToState() async* {
    yield SettingLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield SettingLoaded(setting: Setting());
    } catch (_) {
      yield SettingError();
    }
  }

  Stream<SettingState> _mapUserGotSettingToState(
    UserGotSetting event,
    SettingState state,
  ) async* {
    if (state is SettingLoaded) {
      try {
        yield SettingLoaded(
          setting: Setting(),
        );
      } on Exception {
        yield SettingError();
      }
    }
  }
}
