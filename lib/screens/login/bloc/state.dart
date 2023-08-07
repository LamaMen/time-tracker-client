part of 'bloc.dart';

abstract class LoginState {}

class FetchUserState implements LoginState {
  const FetchUserState();
}

class FetchFailedState implements LoginState {
  final Failure failure;

  const FetchFailedState(this.failure);
}

class SelectUserState implements LoginState {
  final List<User> users;
  final User? currentUser;
  final String password;

  @protected
  const SelectUserState(
    this.users,
    this.currentUser,
    this.password,
  );

  UserCredentials get credentials =>
      UserCredentials(currentUser!.id, password);

  factory SelectUserState.onLoaded(List<User> users) =>
      SelectUserState(users, null, "");

  LoginState changeCurrentUser(User? user) {
    return SelectUserState(users, user, "");
  }

  LoginState changePassword(String password) {
    return SelectUserState(users, currentUser, password);
  }
}

class LoadTokenState extends SelectUserState {
  @protected
  LoadTokenState(SelectUserState state)
      : super(state.users, state.currentUser, state.password);
}

class LoadTokenFailedState extends SelectUserState {
  final Failure failure;

  @protected
  LoadTokenFailedState(this.failure, SelectUserState state)
      : super(state.users, state.currentUser, state.password);
}

class LoginSuccessfulState extends SelectUserState {
  @protected
  LoginSuccessfulState(SelectUserState state)
      : super(state.users, state.currentUser, state.password);
}
