import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

class GeneralProgress {
  final List<ProjectProgress> projectProgress;
  final ProjectDuration total;
  final double totalPercent;

  GeneralProgress(this.projectProgress, this.total, this.totalPercent);

  String get formattedPercent => totalPercent.toStringAsFixed(2);
}

class UserProgress {
  final List<DateTime> dates;
  final List<Project> projects;
  final List<List<ProjectDuration>> durations;
  final List<ProjectDuration> check;
  final List<ProjectDuration> total;

  UserProgress(
    this.dates,
    this.projects,
    this.durations,
    this.check,
    this.total,
  );
}

class ProjectProgress {
  final String project;
  final String duration;
  final double percent;

  ProjectProgress(this.project, ProjectDuration duration, int total)
      : percent = total != 0 ? duration.onlyMinutes * 100 / total : 0,
        duration = duration.toString();

  String get formattedPercent => percent.toStringAsFixed(2);
}
