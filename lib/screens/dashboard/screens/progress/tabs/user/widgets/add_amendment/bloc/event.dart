part of 'bloc.dart';

abstract class AddAmendmentBaseEvent {}

class GetItemsEvent implements AddAmendmentBaseEvent {
  const GetItemsEvent();
}

class ChangeDateEvent implements AddAmendmentBaseEvent {
  final DateTime? date;

  const ChangeDateEvent(this.date);
}

class ChangeHoursEvent implements AddAmendmentBaseEvent {
  final int? hours;

  const ChangeHoursEvent(this.hours);
}

class ChangeMinutesEvent implements AddAmendmentBaseEvent {
  final int? minutes;

  const ChangeMinutesEvent(this.minutes);
}

class ChangePositivesEvent implements AddAmendmentBaseEvent {
  final bool? isPositive;

  const ChangePositivesEvent(this.isPositive);
}

class ChangeUserEvent implements AddAmendmentBaseEvent {
  final User? user;

  const ChangeUserEvent(this.user);
}

class ChangeProjectEvent implements AddAmendmentBaseEvent {
  final Project? project;

  const ChangeProjectEvent(this.project);
}
