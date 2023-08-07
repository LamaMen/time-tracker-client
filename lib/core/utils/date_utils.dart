import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const dateFormat = 'yyyy-MM-dd';

final dateFormatter = DateFormat(dateFormat);

DateTimeRange currentMonth() {
  var now = DateTime.now();
  var start = DateTime(now.year, now.month, 1);
  var end = DateTime(now.year, now.month + 1, 0);
  return DateTimeRange(start: start, end: end);
}

extension DatesGenerator on DateTimeRange? {
  List<DateTime> get dates {
    final range = this ?? currentMonth();
    final dates = <DateTime>[];
    var current = range.start;
    do {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    } while (!current.isAfter(range.end));

    return dates;
  }
}

extension DateUtil on DateTime {
  bool get isHoliday =>
      weekday == DateTime.sunday || weekday == DateTime.saturday;
}
