part of 'bloc.dart';

abstract class GeneralStatEvent {}

class GetStatistic implements GeneralStatEvent {
  final ProgressFilters filters;

  const GetStatistic(this.filters);
}
