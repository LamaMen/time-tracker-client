part of 'bloc.dart';

abstract class ProjectsEvent {}

class _UpdateProjectsEvent implements ProjectsEvent {
  final bool isBackground;

  _UpdateProjectsEvent(this.isBackground);
}

class LoadProjectsEvent extends _UpdateProjectsEvent {
  LoadProjectsEvent() : super(false);
}

class UpdateCurrentProjectEvent implements ProjectsEvent {}

class StartSessionEvent implements ProjectsEvent {
  final Project project;

  StartSessionEvent(this.project);
}

class StopSessionEvent implements ProjectsEvent {
  final Project project;

  StopSessionEvent(this.project);
}

class AddProjectEvent implements ProjectsEvent {
  final String projectName;

  AddProjectEvent(this.projectName);
}
