import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';
import 'package:time_tracker_client/domain/repository/sessions/sessions_repository.dart';
import 'package:time_tracker_client/domain/usecase/projects/project_opened_usecase.dart';

part 'event.dart';

part 'state.dart';

@injectable
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectOpenedUseCase _projectOpenedUseCase;
  final SessionsRepository _sessionsRepository;
  final ProjectsRepository _projectsRepository;
  late Timer timer;

  ProjectsBloc(
    this._projectOpenedUseCase,
    this._sessionsRepository,
    this._projectsRepository,
  ) : super(FetchProjectsState.initial()) {
    on<LoadProjectsEvent>(_onUpdateProjects);
    on<StartSessionEvent>(_onStartSession);
    on<StopSessionEvent>(_onStopSession);
    on<AddProjectEvent>(_onAddProject);
    on<_UpdateProjectsEvent>(_onUpdateProjects);

    timer = Timer.periodic(const Duration(seconds: 15), (_) => _updateScreen());
  }

  void _updateScreen() {
    add(_UpdateProjectsEvent(true));
  }

  Future<void> _onUpdateProjects(
    _UpdateProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    if (!event.isBackground) {
      emit(FetchProjectsState.load(state as ProjectsLoadedState));
    }

    final projects = await _projectOpenedUseCase();
    emit(projects.fold(
      (f) => FetchFailedState(f),
      (u) => ProjectsLoadedState(u),
    ));
  }

  Future<void> _onStartSession(
    StartSessionEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    await _sessionsRepository.startSession(event.project);
    add(_UpdateProjectsEvent(false));
  }

  Future<void> _onStopSession(
    StopSessionEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    await _sessionsRepository.stopSession(event.project);
    add(_UpdateProjectsEvent(false));
  }

  Future<void> _onAddProject(
    AddProjectEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    final project = Project(-1, event.projectName);
    await _projectsRepository.addProject(project);
    add(_UpdateProjectsEvent(false));
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
