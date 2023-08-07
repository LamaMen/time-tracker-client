part of 'bloc.dart';

@immutable
class ProjectsState {
  final bool isFull;

  const ProjectsState(this.isFull);
}

class FetchFailedState extends ProjectsState {
  final Failure failure;

  const FetchFailedState(this.failure, super.isFull);
}

class ProjectsLoadedState extends ProjectsState {
  final List<ProjectWithDuration> projects;

  const ProjectsLoadedState(this.projects, super.isFull);
}

class FetchProjectsState extends ProjectsLoadedState {
  const FetchProjectsState(super.projects, super.isFull);

  factory FetchProjectsState.initial(bool isFull) {
    return FetchProjectsState(const [], isFull);
  }

  factory FetchProjectsState.load(ProjectsLoadedState state) {
    return FetchProjectsState(state.projects, state.isFull);
  }
}
