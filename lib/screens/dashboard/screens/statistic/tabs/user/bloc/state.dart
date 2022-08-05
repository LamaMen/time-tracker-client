part of 'bloc.dart';

abstract class ProgressState {}

class LoadingState implements ProgressState {
  const LoadingState();
}

class FailedState implements ProgressState {
  final Failure failure;

  const FailedState(this.failure);
}

class WithProgressState implements ProgressState {
  final UserProgress progress;

  WithProgressState(this.progress);
}
