enum UserActionType { ENTER_HOME, EXIT_HOME, WIFI }

abstract class UserActionEventObserver {
  void onUserActionChanged(UserActionType action, DateTime time);
}
