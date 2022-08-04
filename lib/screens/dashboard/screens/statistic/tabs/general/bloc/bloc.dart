import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/domain/usecase/progress/general_statistic.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_filters.dart';
import 'package:time_tracker_client/domain/usecase/progress/statistic_usecase.dart';

part 'event.dart';

part 'state.dart';

@injectable
class GeneralStatBloc extends Bloc<GeneralStatEvent, GeneralStatState> {
  final StatisticUsecase _statisticUsecase;

  GeneralStatBloc(this._statisticUsecase) : super(const LoadingState()) {
    on<GetStatistic>(onGet);
  }

  Future<void> onGet(GetStatistic event, Emitter<GeneralStatState> emit) async {
    emit(const LoadingState());
    final statistic = await _statisticUsecase.getGeneral(event.filters);
    emit(statistic.fold(
      (f) => FailedState(f),
      (s) => WithStatisticState(s),
    ));
  }
}
