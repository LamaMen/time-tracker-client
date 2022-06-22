abstract class Failure {
  String get message;

  const Failure();
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

class ServerFailure extends Failure {
  const ServerFailure();

  @override
  String get message => 'Ошибка на сервере';
}
