import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'project_with_duration.g.dart';

@JsonSerializable()
class ProjectWithDuration implements Project {
  @override
  final int id;
  @override
  final String name;
  final ProjectDuration duration;

  ProjectWithDuration(this.id, this.name, this.duration);

  factory ProjectWithDuration.fromJson(Map<String, dynamic> json) =>
      _$ProjectWithDurationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectWithDurationToJson(this);

  String get formattedDuration {
    if (duration.isEmpty) {
      return 'Не начато';
    }

    return 'В работе: ${duration.toString()}';
  }
}

@JsonSerializable()
class ProjectDuration {
  final int hours;
  final int minutes;

  ProjectDuration(this.hours, this.minutes);

  factory ProjectDuration.fromJson(Map<String, dynamic> json) =>
      _$ProjectDurationFromJson(json);

  bool get isEmpty => hours == 0 && minutes == 0;

  @override
  String toString() {
    String result = '';
    if (hours != 0) {
      result += '$hours ч ';
    }

    if (minutes != 0) {
      result += '$minutes м';
    }

    return result;
  }
}


class StartedProject extends ProjectWithDuration {
  StartedProject(ProjectWithDuration project)
      : super(project.id, project.name, project.duration);
}
