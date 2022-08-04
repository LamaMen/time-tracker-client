import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_filters.dart';

part 'event.dart';

part 'state.dart';

@injectable
class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  FiltersBloc(@factoryParam ProgressFilters filters)
      : super(FiltersState(filters.isFull, filters.range)) {
    on<ChangeIsFullEvent>(onChangeIsFull);
    on<ChangeRangeEvent>(onChangeRange);
  }

  Future<void> onChangeIsFull(
    ChangeIsFullEvent event,
    Emitter<FiltersState> emit,
  ) async {
    emit(FiltersState(event.isFull ?? false, state.range));
  }

  Future<void> onChangeRange(
    ChangeRangeEvent event,
    Emitter<FiltersState> emit,
  ) async {
    emit(FiltersState(state.isFull, event.range));
  }
}
