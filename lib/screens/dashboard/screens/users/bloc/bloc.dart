import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/full_user.dart';
import 'package:time_tracker_client/domain/repository/auth/users_repository.dart';

part 'event.dart';

part 'state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository _usersRepository;

  UsersBloc(this._usersRepository) : super(FetchUserState.initial()) {
    on<LoadUsersEvent>(onLoadUsers);
    on<SelectUserEvent>(onSelectUser);
    on<EditUserEvent>(onEditUser);
    on<DeleteUsersEvent>(onDeleteUsers);
  }

  Future<void> onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state is UsersLoadedState
        ? FetchUserState.load(state as UsersLoadedState)
        : FetchUserState.initial());

    final users = await _usersRepository.fetchProtectedUsers();
    emit(users.fold(
      (f) => FetchFailedState(f),
      (users) => UsersLoadedState({for (var u in users) u: false}),
    ));
  }

  Future<void> onSelectUser(
    SelectUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    if (state is! UsersLoadedState) return;
    final users = (state as UsersLoadedState).users;
    users[event.user] = event.isSelected;
    emit(UsersLoadedState(users));
  }

  Future<void> onEditUser(
    EditUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(FetchUserState.load(state as UsersLoadedState));

    final result = await _usersRepository.saveUser(event.user);
    if (result.isLeft()) {
      final failure = (result as Left<Failure, void>).value;
      emit(EditUsersFailureState(state as UsersLoadedState, failure));
      return;
    }

    add(const LoadUsersEvent());
  }

  Future<void> onDeleteUsers(
    DeleteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(FetchUserState.load(state as UsersLoadedState));

    for (var user in event.users) {
      final result = await _usersRepository.deleteUser(user);

      if (result.isLeft()) {
        final failure = (result as Left<Failure, void>).value;
        emit(EditUsersFailureState(state as UsersLoadedState, failure));
        return;
      }
    }

    add(const LoadUsersEvent());
  }
}
