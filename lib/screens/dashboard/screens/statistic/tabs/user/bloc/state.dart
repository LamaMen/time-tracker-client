part of 'bloc.dart';

abstract class ProgressState {
  final User? user;
  final ProgressFilters? filters;

  const ProgressState(this.user, this.filters);
}

class LoadingState extends ProgressState {
  const LoadingState(super.user, super.filters);

  factory LoadingState.fromState(ProgressState state) {
    return LoadingState(state.user, state.filters);
  }
}

class FailedState extends ProgressState {
  final Failure failure;

  FailedState(this.failure, ProgressState state)
      : super(state.user, state.filters);
}

class WithProgressState extends ProgressState {
  final UserProgress progress;

  WithProgressState(this.progress, ProgressState state)
      : super(state.user, state.filters);
}
