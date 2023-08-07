import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'event.dart';

part 'state.dart';

@injectable
class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  EditProjectBloc(@factoryParam Project project)
      : super(EditProjectState(project)) {
    on<ChangeNameEvent>(onChangeName);
    on<ChangeArchiveEvent>(onChangeArchive);
  }

  Future<void> onChangeName(
    ChangeNameEvent event,
    Emitter<EditProjectState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> onChangeArchive(
    ChangeArchiveEvent event,
    Emitter<EditProjectState> emit,
  ) async {
    emit(state.copyWith(isArchive: event.isArchive));
  }
}
