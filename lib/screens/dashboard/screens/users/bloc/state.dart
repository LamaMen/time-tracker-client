part of 'bloc.dart';

@immutable
class UsersState {}

class UsersLoadedState implements UsersState {
  final Map<FullUser, bool> users;

  const UsersLoadedState(this.users);
}

class FetchUserState extends UsersLoadedState {
  FetchUserState(super.users);

  factory FetchUserState.initial() {
    return FetchUserState({});
  }

  factory FetchUserState.load(UsersLoadedState state) {
    return FetchUserState(state.users);
  }
}

class EditUsersFailureState extends UsersLoadedState {
  final Failure failure;

  EditUsersFailureState(UsersLoadedState state, this.failure)
      : super(state.users);
}

class FetchFailedState implements UsersState {
  final Failure failure;

  const FetchFailedState(this.failure);
}
