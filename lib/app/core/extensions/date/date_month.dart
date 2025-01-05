extension MonthDate on DateTime {
  DateTime firstDateInMonth() {
    return DateTime(year, month, 1);
  }

  DateTime lastDateInMonth() {
    return DateTime(year, month + 1, 1,23, 59,59,999).subtract(const Duration(days: 1));
  }
}
