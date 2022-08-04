import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/models/project/project_with_duration.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';

@singleton
class ProjectOpenedUseCase {
  final ProjectsRepository _projectsRepository;

  ProjectOpenedUseCase(this._projectsRepository);

  Future<Either<Failure, List<ProjectWithDuration>>> call(bool isFull) async {
    final projects = await _projectsRepository.fetchProjects(isFull);
    final progress = await _projectsRepository.fetchDailyProgress();

    if (progress.isLeft()) {
      final failure = (progress as Left).value;
      return Left(failure);
    }

    final daily = (progress as Right).value as List<DailyProgress>;
    final dailyProgress = {for (var p in daily) p.projectId: p};

    return projects.map((p) => join(p, dailyProgress));
  }

  List<ProjectWithDuration> join(
    List<Project> projects,
    Map<int, DailyProgress> dailyProgress,
  ) {
    final projectsWithDurations = <ProjectWithDuration>[];

    for (var p in projects) {
      final progress = dailyProgress[p.id];
      final newProject = progress == null
          ? ProjectWithDuration(p, ProjectDuration.empty(), false)
          : ProjectWithDuration(p, progress.duration, progress.inWork);
      projectsWithDurations.add(newProject);
    }

    return projectsWithDurations;
  }
}
