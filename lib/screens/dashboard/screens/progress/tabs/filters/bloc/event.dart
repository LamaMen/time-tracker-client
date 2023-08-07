part of 'bloc.dart';

abstract class FiltersEvent {}

class ChangeIsFullEvent implements FiltersEvent {
  final bool? isFull;

  const ChangeIsFullEvent(this.isFull);
}

class ChangeRangeEvent implements FiltersEvent {
  final DateTimeRange? range;

  const ChangeRangeEvent(this.range);
}
