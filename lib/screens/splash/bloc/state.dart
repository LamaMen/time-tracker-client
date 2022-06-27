part of 'bloc.dart';

@immutable
class SplashState {}

class InitialState implements SplashState {
  const InitialState();
}

class NavigateToLogin implements SplashState {
  const NavigateToLogin();
}

class NavigateToDashboard implements SplashState {
  const NavigateToDashboard();
}
