import 'package:json_annotation/json_annotation.dart';

part 'project_duration.g.dart';

@JsonSerializable(createToJson: false)
class ProjectDuration {
  final int hours;
  final int minutes;

  ProjectDuration(this.hours, this.minutes);

  factory ProjectDuration.fromMinutes(int minutes) {
    final hours = (minutes / 60).floor();
    return ProjectDuration(hours, minutes - hours * 60);
  }

  factory ProjectDuration.empty() {
    return ProjectDuration(0, 0);
  }

  factory ProjectDuration.fromJson(Map<String, dynamic> json) =>
      _$ProjectDurationFromJson(json);

  bool get isEmpty => hours == 0 && minutes == 0;

  int get onlyMinutes => hours * 60 + minutes;

  @override
  String toString() {
    String result = '';
    if (hours != 0) {
      result += '$hours ч ';
    }

    result += '$minutes м';
    return result;
  }
}
