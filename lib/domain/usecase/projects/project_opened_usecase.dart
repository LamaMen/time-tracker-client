import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/data/models/session/session.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';
import 'package:time_tracker_client/domain/repository/sessions/sessions_repository.dart';

@singleton
class ProjectOpenedUseCase {
  final ProjectsRepository _projectsRepository;
  final SessionsRepository _sessionsRepository;

  ProjectOpenedUseCase(this._projectsRepository, this._sessionsRepository);

  Future<Either<Failure, List<ProjectWithDuration>>> call() async {
    var projects = await _projectsRepository.fetchProjects();
    var sessionOr = await _sessionsRepository.getOpenSession();

    if (sessionOr.isLeft()) {
      return sessionOr.map((_) => <ProjectWithDuration>[]);
    }

    final session = (sessionOr as Right<Failure, Session?>).value;
    if (session != null) {
      projects = projects.map((p) => join(p, session));
    }

    return projects;
  }

  List<ProjectWithDuration> join(List<ProjectWithDuration> p, Session s) {
    final projects = List.of(p);
    final index = projects.indexWhere((e) => e.id == s.project.id);
    projects[index] = StartedProject(projects[index]);
    return projects;
  }
}
