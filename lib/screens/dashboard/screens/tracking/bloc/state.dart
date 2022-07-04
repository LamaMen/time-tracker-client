part of 'bloc.dart';

@immutable
class ProjectsState {}

class FetchFailedState implements ProjectsState {
  final Failure failure;

  const FetchFailedState(this.failure);
}

class ProjectsLoadedState implements ProjectsState {
  final List<ProjectWithDuration> projects;

  const ProjectsLoadedState(this.projects);
}

class FetchProjectsState extends ProjectsLoadedState {
  FetchProjectsState(super.projects);

  factory FetchProjectsState.initial() {
    return FetchProjectsState([]);
  }

  factory FetchProjectsState.load(ProjectsLoadedState state) {
    return FetchProjectsState(state.projects);
  }
}
