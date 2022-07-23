import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';
import 'package:time_tracker_client/domain/repository/auth/users_repository.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/tab_type.dart';

part 'event.dart';
part 'state.dart';

@injectable
class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final AuthRepository _authRepository;
  final UsersRepository _usersRepository;

  StatisticBloc(this._authRepository, this._usersRepository)
      : super(const LoadingState()) {
    on<UpdateTabs>(onUpdateTabs);
  }

  Future<void> onUpdateTabs(
    UpdateTabs event,
    Emitter<StatisticState> emit,
  ) async {
    emit(const LoadingState());
    final user = await _authRepository.getCurrentUser();
    final tabs = <TabType>[const GeneralStatisticTab()];

    if (user.role == UserRole.admin) {
      final users = await _usersRepository.fetchUsers();
      emit(_mapUsersToStatistic(users, tabs));
    } else {
      tabs.add(SelfStatisticTab(user));
      emit(WithListState(tabs));
    }
  }

  StatisticState _mapUsersToStatistic(
    Either<Failure, List<User>> users,
    List<TabType> tabs,
  ) {
    return users.fold(
      (f) => FailedState(f),
      (u) {
        for (var user in u) {
          tabs.add(UserStatisticTab(user));
        }
        return WithListState(tabs);
      },
    );
  }
}
