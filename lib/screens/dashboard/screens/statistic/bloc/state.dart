part of 'bloc.dart';

abstract class StatisticState {}

class LoadingState implements StatisticState {
  const LoadingState();
}

class FailedState implements StatisticState {
  final Failure failure;

  const FailedState(this.failure);
}

class WithListState implements StatisticState {
  final List<TabType> statistics;

  WithListState(this.statistics);
}
