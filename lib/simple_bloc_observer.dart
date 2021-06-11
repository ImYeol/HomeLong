import 'package:bloc/bloc.dart';
import 'package:homg_long/log/logger.dart';
import 'package:logging/logging.dart';

class SimpleBlocObserver extends BlocObserver {
  final logUtil = LogUtil();
  final log = Logger("SimpleBlocObserver");

  @override
  void onEvent(Bloc bloc, Object event) {
    log.info('${bloc.runtimeType} $event');
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    log.info('${cubit.runtimeType} $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log.info(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    log.info(change);
    super.onChange(cubit, change);
  }
}
