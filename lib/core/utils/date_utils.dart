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
