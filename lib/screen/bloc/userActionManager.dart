abstract class UserActionManager {
  bool isUserAtHome();
  void onUserLocationChanged(bool atHome);
  void enterHome();
  void exitHome();
  void changeDay();
  Future<int> getTotalTime(DateTime date);
}
