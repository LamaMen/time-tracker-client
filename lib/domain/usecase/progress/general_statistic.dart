import 'package:time_tracker_client/data/models/progress/project_duration.dart';

class GeneralStatistic {
  final List<ProjectProgress> projectProgress;
  final ProjectDuration total;
  final double totalPercent;

  GeneralStatistic(this.projectProgress, this.total, this.totalPercent);

  String get formattedPercent => totalPercent.toStringAsFixed(2);
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
