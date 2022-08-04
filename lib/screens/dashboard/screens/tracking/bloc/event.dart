part of 'bloc.dart';

abstract class ProjectsEvent {}

class _UpdateProjectsEvent implements ProjectsEvent {
  final bool isBackground;

  _UpdateProjectsEvent(this.isBackground);
}

class LoadProjectsEvent extends _UpdateProjectsEvent {
  LoadProjectsEvent() : super(false);
}

class StartSessionEvent implements ProjectsEvent {
  final Project project;

  StartSessionEvent(this.project);
}

class StopSessionEvent implements ProjectsEvent {
  final Project project;

  StopSessionEvent(this.project);
}

class AddProjectEvent implements ProjectsEvent {
  final Project project;

  AddProjectEvent(this.project);
}

class UpdateProjectEvent implements ProjectsEvent {
  final Project project;

  UpdateProjectEvent(this.project);
}

class DeleteProjectEvent implements ProjectsEvent {
  final Project project;
  final bool isArchive;

  DeleteProjectEvent(this.project, this.isArchive);
}

class ChangeFlagEvent implements ProjectsEvent {
  final bool isFull;

  const ChangeFlagEvent(this.isFull);
}