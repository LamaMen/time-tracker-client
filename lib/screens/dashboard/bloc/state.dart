part of 'bloc.dart';

abstract class AuthState {}

class LoadUserState implements AuthState {
  const LoadUserState();
}

class UserState implements AuthState {
  final User user;

  const UserState(this.user);
}

class LogOutState implements AuthState {
  const LogOutState();
}