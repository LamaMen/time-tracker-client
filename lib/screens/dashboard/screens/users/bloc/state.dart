part of 'bloc.dart';

@immutable
class UsersState {}

class FetchUserState implements UsersState {
  const FetchUserState();
}

class FetchFailedState implements UsersState {
  final Failure failure;

  const FetchFailedState(this.failure);
}

class UsersLoadedState implements UsersState {
  final List<User> users;

  const UsersLoadedState(this.users);
}
