part of 'bloc.dart';

abstract class GeneralStatState {}

class LoadingState implements GeneralStatState {
  const LoadingState();
}

class FailedState implements GeneralStatState {
  final Failure failure;

  const FailedState(this.failure);
}

class WithProgressState implements GeneralStatState {
  final GeneralProgress statistics;

  WithProgressState(this.statistics);
}
