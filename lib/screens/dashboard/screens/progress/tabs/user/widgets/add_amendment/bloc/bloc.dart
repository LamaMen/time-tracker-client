import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/amendment.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/repository/projects/projects_repository.dart';

part 'event.dart';

part 'state.dart';

@injectable
class AddAmendmentBloc extends Bloc<AddAmendmentBaseEvent, AddAmendmentState> {
  final ProjectsRepository _projectsRepository;

  AddAmendmentBloc(
    this._projectsRepository,
  ) : super(const LoadItemsState()) {
    on<GetItemsEvent>(onGetItems);
    on<ChangeDateEvent>(onChangeDate);
    on<ChangeHoursEvent>(onChangeHours);
    on<ChangeMinutesEvent>(onChangeMinutes);
    on<ChangePositivesEvent>(onChangePositives);
    on<ChangeUserEvent>(onChangeUser);
    on<ChangeProjectEvent>(onChangeProject);
  }

  Future<void> onGetItems(
    GetItemsEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    emit(const LoadItemsState());
    final projects = await _projectsRepository.fetchProjects(true);
    emit(projects.fold(
      (f) => LoadFailedState(f),
      (p) => SelectItemsState.initial(p),
    ));
  }

  Future<void> onChangeDate(
    ChangeDateEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(date: event.date));
  }

  Future<void> onChangeHours(
    ChangeHoursEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(hours: event.hours));
  }

  Future<void> onChangeMinutes(
    ChangeMinutesEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(minutes: event.minutes));
  }

  Future<void> onChangePositives(
    ChangePositivesEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(isPositive: event.isPositive));
  }

  Future<void> onChangeUser(
    ChangeUserEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(user: event.user));
  }

  Future<void> onChangeProject(
    ChangeProjectEvent event,
    Emitter<AddAmendmentState> emit,
  ) async {
    if (state is! SelectItemsState) return;
    final params = state as SelectItemsState;
    emit(params.copyWith(project: event.project));
  }
}
