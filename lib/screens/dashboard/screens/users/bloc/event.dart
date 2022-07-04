part of 'bloc.dart';

abstract class UsersEvent {}

class LoadUsersEvent implements UsersEvent {
  const LoadUsersEvent();
}
