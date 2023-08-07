part of 'bloc.dart';

abstract class UsersEvent {}

class LoadUsersEvent implements UsersEvent {
  const LoadUsersEvent();
}

class SelectUserEvent implements UsersEvent {
  final FullUser user;
  final bool isSelected;

  SelectUserEvent(this.user, this.isSelected);
}

class EditUserEvent implements UsersEvent {
  final FullUser user;

  EditUserEvent(this.user);
}

class DeleteUsersEvent implements UsersEvent {
  final List<FullUser> users;

  DeleteUsersEvent(this.users);
}
