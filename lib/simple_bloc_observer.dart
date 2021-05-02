import 'package:bloc/bloc.dart';
import 'package:homg_long/log/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  final logUtil = LogUtil();
  @override
  void onEvent(Bloc bloc, Object event) {
    logUtil.logger.d('${bloc.runtimeType} $event');
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    logUtil.logger.d('${cubit.runtimeType} $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logUtil.logger.d(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    logUtil.logger.d(change);
    super.onChange(cubit, change);
  }
}
