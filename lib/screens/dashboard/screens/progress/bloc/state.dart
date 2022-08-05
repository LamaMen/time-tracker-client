part of 'bloc.dart';

abstract class StatisticState {}

class LoadingState implements StatisticState {
  const LoadingState();
}

class FailedState implements StatisticState {
  final Failure failure;

  const FailedState(this.failure);
}

class WithTabsState implements StatisticState {
  final List<TabType> tabs;
  final ProgressFilters filters;

  const WithTabsState(this.tabs, this.filters);
}
