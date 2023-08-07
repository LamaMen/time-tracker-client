part of 'bloc.dart';

abstract class LoginEvent {}

class FetchUsers implements LoginEvent {
  const FetchUsers();
}

class ChangeUser implements LoginEvent {
  final User? user;

  const ChangeUser(this.user);
}

class ChangePassword implements LoginEvent {
  final String password;

  const ChangePassword(this.password);
}

class TryLogin implements LoginEvent {
  const TryLogin();
}
