import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';
import 'package:time_tracker_client/domain/repository/progress/statistic_repository.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';
import 'package:time_tracker_client/domain/usecase/progress/general_statistic.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_filters.dart';

@singleton
class StatisticUsecase {
  final ProgressRepository _statisticRepository;
  final ProjectsRepository _projectsRepository;
  final AuthRepository _authRepository;

  StatisticUsecase(
    this._statisticRepository,
    this._projectsRepository,
    this._authRepository,
  );

  Future<Either<Failure, GeneralStatistic>> getGeneral(
    ProgressFilters filters,
  ) async {
    final rawProjects = await _projectsRepository.fetchProjects(filters.isFull);
    if (rawProjects.isLeft()) return Left((rawProjects as Left).value);
    final projects = (rawProjects as Right).value as List<Project>;

    final user = await _authRepository.getCurrentUser();
    final rawProgress = await _statisticRepository.fetchGeneral(
      user.role == UserRole.admin,
      filters.range?.start,
      filters.range?.end,
    );

    if (rawProgress.isLeft()) return Left((rawProgress as Left).value);
    final progress = (rawProgress as Right).value as List<Progress>;
    final progressMap = {for (var p in progress) p.projectId: p};

    final tMinutes = progress.fold<int>(0, (s, p) {
      return s + p.duration.onlyMinutes;
    });

    final statistic = projects.map((p) {
      final duration = progressMap[p.id]?.duration ?? ProjectDuration.empty();
      return ProjectProgress(p.name, duration, tMinutes);
    }).toList();

    final tPercent = statistic.fold<double>(0.0, (s, p) => s + p.percent);

    final general = GeneralStatistic(
      statistic,
      ProjectDuration.fromMinutes(tMinutes),
      tPercent,
    );

    return Right(general);
  }
}
