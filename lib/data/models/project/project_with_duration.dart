import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'project_with_duration.g.dart';

@JsonSerializable(createToJson: false)
class ProjectWithDuration {
  final Project project;
  final ProjectDuration duration;

  ProjectWithDuration(this.project, this.duration);

  factory ProjectWithDuration.fromJson(Map<String, dynamic> json) =>
      _$ProjectWithDurationFromJson(json);

  ProjectWithDuration updateProject(Project project) {
    return ProjectWithDuration(project, duration);
  }

  String get formattedDuration {
    if (duration.isEmpty) {
      return 'Не начато';
    }

    return 'В работе: ${duration.toString()}';
  }
}

@JsonSerializable(createToJson: false)
class ProjectDuration {
  final int hours;
  final int minutes;

  ProjectDuration(this.hours, this.minutes);

  factory ProjectDuration.fromMinutes(int minutes) {
    final hours = (minutes / 60).floor();
    return ProjectDuration(hours, minutes - hours * 60);
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
