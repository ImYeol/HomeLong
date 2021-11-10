enum UserActionType { ENTER_HOME, EXIT_HOME }

abstract class UserActionEventObserver {
  void onUserActionChanged(UserActionType action, DateTime time);
}
