part of 'bloc.dart';

abstract class StatisticEvent {}

class UpdateTabs implements StatisticEvent {
  const UpdateTabs();
}

class UpdateFilters implements StatisticEvent {
  final ProgressFilters filters;

  const UpdateFilters(this.filters);
}
