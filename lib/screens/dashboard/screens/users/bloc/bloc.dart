import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/repository/auth/user_repository.dart';

part 'event.dart';

part 'state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository _usersRepository;

  UsersBloc(this._usersRepository) : super(const FetchUserState()) {
    on<LoadUsersEvent>(onLoadUsers);
  }

  Future<void> onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    final users = await _usersRepository.fetchUsers();
    emit(users.fold((f) => FetchFailedState(f), (u) => UsersLoadedState(u)));
  }
}
