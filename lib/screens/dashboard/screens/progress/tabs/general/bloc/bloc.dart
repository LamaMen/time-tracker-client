import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/domain/models/progress/general_progress.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_usecase.dart';

part 'event.dart';
part 'state.dart';

@injectable
class GeneralStatBloc extends Bloc<GeneralStatEvent, GeneralStatState> {
  final ProgressUsecase _progressUsecase;

  GeneralStatBloc(this._progressUsecase) : super(const LoadingState()) {
    on<GetStatistic>(onGet);
  }

  Future<void> onGet(GetStatistic event, Emitter<GeneralStatState> emit) async {
    emit(const LoadingState());
    final progress = await _progressUsecase.getGeneral(event.filters);
    emit(progress.fold(
      (f) => FailedState(f),
      (s) => WithProgressState(s),
    ));
  }
}
