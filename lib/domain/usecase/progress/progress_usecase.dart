import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';
import 'package:time_tracker_client/domain/repository/progress/progress_repository.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';
import 'package:time_tracker_client/domain/models/progress/general_statistic.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';

@singleton
class ProgressUsecase {
  final format = DateFormat('yyyy-MM-dd');
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
    final rawProjects = await _projectsRepository.fetchProjects(filters.isFull);
    if (rawProjects.isLeft()) return Left((rawProjects as Left).value);
    final projects = (rawProjects as Right).value as List<Project>;

    final user = await _authRepository.getCurrentUser();
    final rawProgress = await _statisticRepository.fetchGeneral(
      user.role == UserRole.admin,
      filters.range,
    );

    if (rawProgress.isLeft()) return Left((rawProgress as Left).value);
    final progress = (rawProgress as Right).value as List<Progress>;
    final progressMap = _getProgressMap(progress);

    final tMinutes = progress.fold<int>(0, (s, p) {
      return s + p.duration.onlyMinutes;
    });

    final statistic = projects.map((p) {
      final duration = progressMap[p.id]?.duration ?? ProjectDuration.empty();
      return ProjectProgress(p.name, duration, tMinutes);
    }).toList();

    final tPercent = statistic.fold<double>(0.0, (s, p) => s + p.percent);

    final general = GeneralProgress(
      statistic,
      ProjectDuration.fromMinutes(tMinutes),
      tPercent,
    );

    return Right(general);
  }

  Future<Either<Failure, UserProgress>> getProgress(
    String? userId,
    ProgressFilters filters,
  ) async {
    final rawProjects = await _projectsRepository.fetchProjects(filters.isFull);
    if (rawProjects.isLeft()) return Left((rawProjects as Left).value);
    final projects = (rawProjects as Right).value as List<Project>;

    final raw = await _statisticRepository.fetchProgress(
      userId,
      filters.range,
    );

    if (raw.isLeft()) return Left((raw as Left).value);
    final progress = (raw as Right).value as Map<String, List<Progress>>;

    final dates = _generateDates(filters.range);
    final List<List<ProjectDuration>> durations = [];
    final check = <ProjectDuration>[];
    final totalM = projects.map((_) => 0).toList();

    final progressMap = _mergeDatesAndProgress(progress, projects);

    for (int i = 0; i < dates.length; i++) {
      final projectToDuration = progressMap[dates[i]] ?? {};
      durations.add([]);
      var minutes = 0;
      for (int j = 0; j < projects.length; j++) {
        final duration =
            projectToDuration[projects[j]] ?? ProjectDuration.empty();
        durations[i].add(duration);
        minutes += duration.onlyMinutes;
        totalM[j] += duration.onlyMinutes;
      }

      final checkDuration = ProjectDuration.fromMinutes(minutes);
      check.add(checkDuration);
    }

    final total = totalM.map((m) => ProjectDuration.fromMinutes(m)).toList();
    final totalS = totalM.fold<int>(0, (s, t) => s + t);
    check.add(ProjectDuration.fromMinutes(totalS));

    return Right(UserProgress(dates, projects, durations, check, total));
  }

  Map<int, Progress> _getProgressMap(List<Progress> projects) {
    return {for (var p in projects) p.projectId: p};
  }

  List<DateTime> _generateDates(DateTimeRange? range) {
    range ??= currentMonth();
    final dates = <DateTime>[];
    var current = range.start;
    do {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    } while (!current.isAfter(range.end));

    return dates;
  }

  Map<DateTime, Map<Project, ProjectDuration>> _mergeDatesAndProgress(
    Map<String, List<Progress>> progress,
    List<Project> projects,
  ) {
    return progress.map((d, p) {
      final date = format.parse(d);
      final progress = _getProgressMap(p);
      final durations = {
        for (var i in projects)
          i: progress[(i).id]?.duration ?? ProjectDuration.empty()
      };
      return MapEntry(date, durations);
    });
  }
}
