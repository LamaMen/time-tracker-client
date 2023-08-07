abstract class Failure {
  String get message;
}

class UnknownFailure implements Failure {
  const UnknownFailure();

  @override
  String get message => 'Что-то пошло не так';
}

class NoInternetFailure implements Failure {
  const NoInternetFailure();

  @override
  String get message => 'Нет интернета';
}

class WrongCredentialsFailure implements Failure {
  const WrongCredentialsFailure();

  @override
  String get message => 'Неправильный пароль';
}

class ServerFailure implements Failure {
  const ServerFailure();

  @override
  String get message => 'Ошибка на сервере';
}

class EditYourselfRoleFailure implements Failure {
  const EditYourselfRoleFailure();

  @override
  String get message => 'Вы пытаетесь поменять роль у самого себя';
}

class DeleteYourselfRoleFailure implements Failure {
  const DeleteYourselfRoleFailure();

  @override
  String get message => 'Вы пытаетесь удалить себя';
}
