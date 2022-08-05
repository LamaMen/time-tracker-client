part of 'bloc.dart';

abstract class ProgressEvent {}

class GetStatistic implements ProgressEvent {
  final User? user;
  final ProgressFilters filters;

  const GetStatistic(this.user, this.filters);
}
