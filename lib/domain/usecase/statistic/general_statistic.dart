import 'package:time_tracker_client/data/models/project/project_with_duration.dart';

class GeneralStatistic {
  final List<ProjectProgress> projectProgress;
  final ProjectDuration total;
  final double totalPercent;

  GeneralStatistic(this.projectProgress, this.total, this.totalPercent);

  String get formattedPercent => totalPercent.toStringAsFixed(2);
}

class ProjectProgress extends ProjectWithDuration {
  final double percent;

  ProjectProgress(ProjectWithDuration project, int total)
      : percent = project.duration.onlyMinutes * 100 / total,
        super(project.project, project.duration);

  String get formattedPercent => percent.toStringAsFixed(2);
}
