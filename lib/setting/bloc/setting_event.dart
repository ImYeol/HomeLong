part of 'setting_bloc.dart';

@immutable
abstract class SettingEvent extends Equatable {
  const SettingEvent();
}

class SettingStarted extends SettingEvent {
  @override
  List<Object> get props => [];
}

class UserGotSetting extends SettingEvent {
  @override
  List<Object> get props => [];
}
