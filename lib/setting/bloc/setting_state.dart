part of 'setting_bloc.dart';

@immutable
abstract class SettingState extends Equatable {
  const SettingState();
}

class SettingLoading extends SettingState {
  @override
  List<Object> get props => [];
}

class SettingLoaded extends SettingState {
  const SettingLoaded({this.setting});

  final Setting setting;

  @override
  List<Object> get props => [setting];
}

class SettingError extends SettingState {
  @override
  List<Object> get props => [];
}
