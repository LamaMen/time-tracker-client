part of 'bloc.dart';

abstract class AuthEvent {}

class GetUserEvent implements AuthEvent {
  const GetUserEvent();
}

class LogOutEvent implements AuthEvent {
  const LogOutEvent();
}
