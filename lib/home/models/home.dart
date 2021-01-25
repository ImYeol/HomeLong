class Home {
  static final String AT_HOME_TITLE = "Staying At Home For";
  static final String OUT_HOME_TITLE = "Not Staying At Home";

  int hourAverageOfWeek;
  int hourAverageOfMonth;

  int onHourTimeAtHome;
  int onMinuteTimeAtHome;

  String title;

  Home(
      {this.hourAverageOfWeek = 0,
      this.hourAverageOfMonth = 0,
      this.onHourTimeAtHome = 0,
      this.onMinuteTimeAtHome = 0,
      this.title});

  set onHourTime(int hourTime) {
    this.onHourTimeAtHome = hourTime;
  }

  set onMinuteTime(int minuteTime) {
    this.onMinuteTimeAtHome = minuteTime;
  }
}
