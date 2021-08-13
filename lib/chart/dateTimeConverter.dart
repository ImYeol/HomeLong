abstract class DateTimeConverter {
  static String dateToString(int date) {
    return "Invalid";
  }
}

class WeekDayStringConverter extends DateTimeConverter {
  static String dateToString(int date) {
    switch (date) {
      case DateTime.monday:
        return "MON";
      case DateTime.tuesday:
        return "TUE";
      case DateTime.wednesday:
        return "WED";
      case DateTime.thursday:
        return "THR";
      case DateTime.friday:
        return "FRI";
      case DateTime.saturday:
        return "SAT";
      case DateTime.sunday:
        return "SUN";
      default:
        return "Invalid";
    }
  }
}

class MonthStringConverter extends DateTimeConverter {
  static String dateToString(int date) {
    switch (date) {
      case DateTime.january:
        return "january";
      case DateTime.february:
        return "february";
      case DateTime.march:
        return "march";
      case DateTime.april:
        return "april";
      case DateTime.may:
        return "may";
      case DateTime.june:
        return "june";
      case DateTime.july:
        return "july";
      case DateTime.august:
        return "august";
      case DateTime.september:
        return "september";
      case DateTime.october:
        return "october";
      case DateTime.november:
        return "november";
      case DateTime.december:
        return "december";
      default:
        return "Invalid";
    }
  }
}
