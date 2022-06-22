part of 'bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class FetchUsers extends LoginEvent {
  const FetchUsers();
}

class ChangeUser extends LoginEvent {
  final User? user;

  const ChangeUser(this.user);
}

class ChangePassword extends LoginEvent {
  final String password;

  const ChangePassword(this.password);
}

class TryLogin extends LoginEvent {
  const TryLogin();
}
