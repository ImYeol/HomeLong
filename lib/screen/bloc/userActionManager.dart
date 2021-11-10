import 'package:homg_long/screen/bloc/userActionEventObserver.dart';

abstract class UserActionManager {
  bool isUserAtHome();
  void onUserLocationChanged(bool atHome);
  void enterHome();
  void exitHome();
  void registerUserActionEventObserver(UserActionEventObserver observer);
}
