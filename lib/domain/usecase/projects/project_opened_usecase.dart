import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';

@singleton
class ProjectOpenedUseCase {
  final ProjectsRepository _projectsRepository;

  ProjectOpenedUseCase(this._projectsRepository);

  Future<Either<Failure, List<ProjectWithDuration>>> call() async {
    var projects = await _projectsRepository.fetchProjects();
    var inWorkProject = await _projectsRepository.getInWorkProject();

    if (inWorkProject.isLeft()) {
      final failure = (inWorkProject as Left).value;
      return Left(failure);
    }

    final inWork = (inWorkProject as Right).value;
    if (inWork != null) {
      projects = projects.map((p) => join(p, inWork));
    }

    return projects;
  }

  List<ProjectWithDuration> join(
      List<ProjectWithDuration> p, InWorkProject inWork) {
    final projects = List.of(p);
    final i = projects.indexWhere((e) => e.project.id == inWork.id);
    projects[i] = projects[i].updateProject(inWork);
    return projects;
  }
}
