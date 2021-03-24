/// Extension on the [DateTime] class to allow further validation for [DateTime] checks
/// perfomed for specific calendar features.
extension DateTimeValidation on DateTime {
  /// States wheter the this [DateTime] object is in the same calendar week as the
  /// provided [DateTime] object.
  bool isSameCalendarWeek(DateTime other) {
    int currentWeekday = this.weekday;
    DateTime rangeStart =
        DateTime(this.year, this.month, this.day - (currentWeekday - 1));
    DateTime rangeEnd =
        DateTime(this.year, this.month, this.day + (7 - currentWeekday));

    bool rangeStartCondition =
        other.isAfter(rangeStart) || other.isAtSameMomentAs(rangeStart);
    bool rangeEndCondition =
        other.isBefore(rangeEnd) || other.isAtSameMomentAs(rangeEnd);
    return rangeStartCondition && rangeEndCondition;
  }

  /// States whether this [DateTime] object is in the same calendar month as the
  /// provided [DateTime] object.
  bool isSameCalendarMonth(DateTime other) {
    return other.year == this.year && other.month == this.month;
  }

  /// Returns the last day of the month / end of month.
  ///
  /// In order to determine the last day of the month, the day value on the [DateTime]
  /// constructor will be set to 0 while the total month will be increased by one. This
  /// will return the day one day before the month will start.
  ///
  /// This will eventually subtract one day from the increased month.
  int lastDayOfMonth() {
    return DateTime(this.year, this.month + 1, 0).day;
  }
}
