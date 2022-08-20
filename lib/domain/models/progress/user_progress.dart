import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

class UserProgress extends Iterable<Line> {
  final List<DateTime> dates;
  final List<Project> projects;
  final List<List<ProjectDuration>> durations;
  final List<ProjectDuration> total;

  UserProgress(
    this.dates,
    this.projects,
    this.durations,
    this.total,
  ) : assert(dates.length == durations.length);

  int get _lineCount => dates.length + 1;

  List<String> get columns {
    final List<String> columns = [];
    columns.add('Дата');
    for (var p in projects) {
      columns.add(p.name);
    }
    columns.add('Проверка');
    return columns;
  }

  @override
  Iterator<Line> get iterator => _UserProgressIterator(this);
}

class _UserProgressIterator implements Iterator<Line> {
  final UserProgress values;
  int _currentLine = 0;

  _UserProgressIterator(this.values);

  @override
  Line get current {
    return isLast
        ? _TotalLine(values.total)
        : _DateLine(
            durations: values.durations[_currentLine - 1],
            date: values.dates[_currentLine - 1],
          );
  }

  bool get isLast => _currentLine == values._lineCount;

  @override
  bool moveNext() {
    if (_currentLine == values._lineCount) return false;
    _currentLine++;
    return true;
  }
}

abstract class Line extends Iterable<String> {
  final List<ProjectDuration> durations;

  Line({required this.durations});

  Color get background;

  @protected
  String get title;

  @override
  Iterator<String> get iterator => _LineIterator(durations, title);
}

class _LineIterator implements Iterator<String> {
  final List<ProjectDuration> durations;
  final String title;

  int _currentElement = 0;

  _LineIterator(this.durations, this.title);

  @override
  String get current {
    if (isFirst) return title;

    final duration = isLast ? _check : durations[_currentElement - 2];
    return duration.toString();
  }

  @override
  bool moveNext() {
    if (_currentElement == durations.length + 2) return false;
    _currentElement++;
    return true;
  }

  ProjectDuration get _check {
    final minutes = durations.fold<int>(0, (s, t) => s + t.onlyMinutes);
    return ProjectDuration.fromMinutes(minutes);
  }

  bool get isFirst => _currentElement == 1;

  bool get isLast => _currentElement == durations.length + 2;
}

class _DateLine extends Line {
  final DateTime _date;

  @override
  Color get background => _date.isHoliday ? Colors.red : Colors.white;

  _DateLine({
    required super.durations,
    required DateTime date,
  }) : _date = date;

  @override
  String get title {
    initializeDateFormatting();
    final format = DateFormat('d.MMMyyyy, EEE', 'ru');
    return format.format(_date);
  }
}

class _TotalLine extends Line {
  _TotalLine(List<ProjectDuration> durations) : super(durations: durations);

  @override
  Color get background => const Color.fromRGBO(250, 250, 250, 1);

  @override
  String get title => 'Всего';
}
