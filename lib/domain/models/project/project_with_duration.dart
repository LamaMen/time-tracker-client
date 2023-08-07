import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

class ProjectWithDuration {
  final Project project;
  final ProjectDuration duration;
  final bool inWork;

  ProjectWithDuration(this.project, this.duration, this.inWork);

  String get formattedDuration {
    if (duration.isEmpty) {
      return 'Не начато';
    }

    return 'В работе: ${duration.toString()}';
  }
}