class DateHelper {
  static bool isValidDateBirth(String date, String format) {
    try {
      int day, month, year;
      String separator = RegExp("([-/.])").firstMatch(date).group(0)[0];
      var frSplit = format.split(separator);
      var dtSplit = date.split(separator);
      for (int i = 0; i < frSplit.length; i++) {
        var frm = frSplit[i].toLowerCase();
        var vl = dtSplit[i];
        if (frm == "dd")
          day = int.parse(vl);
        else if (frm == "mm")
          month = int.parse(vl);
        else if (frm == "yyyy") year = int.parse(vl);
      }
      var now = DateTime.now();
      if (month > 12 ||
          month < 1 ||
          day < 1 ||
          day > daysInMonth(month, year) ||
          year < 1810 ||
          (year > now.year && day > now.day && month > now.month))
        throw Exception("Date birth invalid.");
      return true;
    } catch (e) {
      return false;
    }
  }

  static int daysInMonth(int month, int year) {
    int days = 28 +
        (month + (month / 8).floor()) % 2 +
        2 % month +
        2 * (1 / month).floor();
    return (isLeapYear(year) && month == 2) ? 29 : days;
  }

  static bool isLeapYear(int year) =>
      ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
}
