part of 'bloc.dart';

abstract class ProgressEvent {}

class GetStatistic implements ProgressEvent {
  final User? user;
  final ProgressFilters filters;

  const GetStatistic(this.user, this.filters);
}

class _UpdateProgress implements ProgressEvent{
  const _UpdateProgress();
}

class AddAmendmentEvent implements ProgressEvent {
  final Amendment amendment;

  const AddAmendmentEvent(this.amendment);
}
