import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/models/progress/general_progress.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/domain/models/progress/user_progress.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';
import 'package:time_tracker_client/domain/repository/progress/progress_repository.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';

@singleton
class ProgressUsecase {
  final ProgressRepository _statisticRepository;
  final ProjectsRepository _projectsRepository;
  final AuthRepository _authRepository;

  ProgressUsecase(
    this._statisticRepository,
    this._projectsRepository,
    this._authRepository,
  );

  Future<Either<Failure, GeneralProgress>> getGeneral(
    ProgressFilters filters,
  ) async {
    final projects = await _projectsRepository.fetchProjects(filters.isFull);
    if (projects.isLeft) return Left(projects.left);

    final user = await _authRepository.getCurrentUser();
    final progress = await _statisticRepository.fetchGeneral(
        user.role == UserRole.admin, filters.range);
    if (progress.isLeft) return Left(progress.left);

    final general = _getGeneralProgress(projects.right, progress.right);
    return Right(general);
  }

  GeneralProgress _getGeneralProgress(
    List<Project> projects,
    List<Progress> progress,
  ) {
    final durations = _getDurationsByProject(progress, projects);
    final totalMinutes = progress.fold<int>(0, (s, p) {
      return s + p.duration.onlyMinutes;
    });

    final statistic = durations.entries.map((e) {
      return ProjectProgress(e.key.name, e.value, totalMinutes);
    }).toList();

    final totalPercent = statistic.fold<double>(0.0, (s, p) => s + p.percent);

    return GeneralProgress(
      statistic,
      ProjectDuration.fromMinutes(totalMinutes),
      totalPercent,
    );
  }

  Future<Either<Failure, UserProgress>> getProgress(
    String? userId,
    ProgressFilters filters,
  ) async {
    final projects = await _projectsRepository.fetchProjects(filters.isFull);
    if (projects.isLeft) return Left(projects.left);

    final progress =
        await _statisticRepository.fetchProgress(userId, filters.range);
    if (progress.isLeft) return Left(progress.left);

    final userProgress = _getProgress(filters, projects.right, progress.right);
    return Right(userProgress);
  }

  UserProgress _getProgress(
    ProgressFilters filters,
    List<Project> projects,
    Map<String, List<Progress>> progress,
  ) {
    final dates = filters.range.dates;
    final List<List<ProjectDuration>> durations = [];
    final totalMinutes = projects.map((_) => 0).toList();

    final progressByDays = _mergeDatesAndProgress(progress, projects);

    for (int i = 0; i < dates.length; i++) {
      final progressInDay = progressByDays[dates[i]] ?? {};
      durations.add([]);
      for (int j = 0; j < projects.length; j++) {
        final duration = progressInDay[projects[j]] ?? ProjectDuration.empty();
        durations[i].add(duration);
        totalMinutes[j] += duration.onlyMinutes;
      }
    }

    final total = totalMinutes.map((m) {
      return ProjectDuration.fromMinutes(m);
    }).toList();

    return UserProgress(dates, projects, durations, total);
  }

  Map<Project, ProjectDuration> _getDurationsByProject(
    List<Progress> progress,
    List<Project> projects,
  ) {
    final progressById = {for (var p in progress) p.projectId: p};
    return {
      for (var i in projects)
        i: progressById[i.id]?.duration ?? ProjectDuration.empty()
    };
  }

  Map<DateTime, Map<Project, ProjectDuration>> _mergeDatesAndProgress(
    Map<String, List<Progress>> progress,
    List<Project> projects,
  ) {
    return progress.map((d, p) {
      final date = dateFormatter.parse(d);
      final durations = _getDurationsByProject(p, projects);
      return MapEntry(date, durations);
    });
  }
}
