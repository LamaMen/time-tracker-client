import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/amendment.dart';
import 'package:time_tracker_client/domain/models/progress/general_statistic.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/domain/repository/progress/progress_repository.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_usecase.dart';

part 'event.dart';

part 'state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressUsecase _progressUsecase;
  final ProgressRepository _progressRepository;

  ProgressBloc(
    this._progressUsecase,
    this._progressRepository,
  ) : super(const LoadingState(null, null)) {
    on<GetStatistic>(onGet);
    on<_UpdateProgress>(_onUpdate);
    on<AddAmendmentEvent>(onAddAmendment);
  }

  Future<void> onGet(GetStatistic event, Emitter<ProgressState> emit) async {
    emit(LoadingState(event.user, event.filters));
    add(const _UpdateProgress());
  }

  Future<void> _onUpdate(
    _UpdateProgress event,
    Emitter<ProgressState> emit,
  ) async {
    final progress = await _progressUsecase.getProgress(
      state.user?.id,
      state.filters!,
    );

    emit(progress.fold(
      (f) => FailedState(f, state),
      (s) => WithProgressState(s, state),
    ));
  }

  Future<void> onAddAmendment(
    AddAmendmentEvent event,
    Emitter<ProgressState> emit,
  ) async {
    await _progressRepository.addAmendment(event.amendment);
    add(const _UpdateProgress());
  }
}
